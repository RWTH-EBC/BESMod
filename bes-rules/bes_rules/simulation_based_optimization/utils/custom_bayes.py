from __future__ import annotations

import logging
from typing import TYPE_CHECKING
from itertools import product

from openpyxl.descriptors import String

from bayes_opt import acquisition
from bayes_opt.event import Events
from pyDOE import lhs
from bayes_opt import BayesianOptimization, acquisition

if TYPE_CHECKING:
    from collections.abc import Callable, Mapping

    import numpy as np
    from numpy.random import RandomState
    from scipy.optimize import NonlinearConstraint

    from bayes_opt.acquisition import AcquisitionFunction
    from bayes_opt.domain_reduction import DomainTransformer


class ExplorationAcquisition(acquisition.AcquisitionFunction):

    def __init__(self, random_state=None):
        super().__init__(random_state)

    def base_acq(self, mean, std):
        logging.debug(f"std={std}, mean={mean}")
        return 1e8 * std  # disregard std


class CustomBayesianOptimization(BayesianOptimization):

    def _prime_queue(self, initialization_method):
        if initialization_method == "central_points":
            bounds = self.space.bounds  # Assuming [(min1, max1), (min2, max2), ...]
            dim = len(bounds)

            # Generate corner points: Cartesian product of min and max bounds for each dimension
            corner_points = list(product(*[(min_bound, max_bound) for min_bound, max_bound in bounds]))

            # Generate midpoints for each dimension
            midpoints = [((min_bound + max_bound) / 2) for min_bound, max_bound in bounds]

            # Generate middle points (edge midpoints along boundaries) using list comprehension
            middle_points = [
                tuple(mid_point if j == i else corner[j] for j in range(dim))
                for i in range(dim)
                for corner in corner_points
                for mid_point in [midpoints[i]]
            ]

            # Add center point (all midpoints)
            center_point = tuple(midpoints)

            # Combine all points (corner, middle, and center)
            all_points = list(set(corner_points + middle_points + [center_point]))  # Use set to avoid duplicates

            # Prime the queue with these points
            for point in all_points:
                self._queue.append(tuple(point))  # Use append instead of add

        elif initialization_method == "latin_hypercube_design":
            """
            Prime the optimization process with Latin Hypercube Sampling (LHS).
            """
            bounds = self.space.bounds
            dim = len(bounds)

            # Generate LHS samples
            n_samples = max(10, 2 ** dim)
            lhs_samples = lhs(dim, samples=n_samples)

            # Scale samples to the bounds
            scaled_samples = np.zeros((n_samples, dim))
            for i in range(dim):
                scaled_samples[:, i] = bounds[i][0] + lhs_samples[:, i] * (bounds[i][1] - bounds[i][0])

            # Prime the queue with these samples
            for point in scaled_samples:
                self._queue.append(tuple(point))

        elif initialization_method == "reload_old_simulations":
            for point in self.points_injected:
                self._queue.append(tuple(point))


def convergence_dummy(x, y):
    return 1 * y ** 2 + 2 * y + 0.5 * x + 2000


if __name__ == '__main__':
    pbounds = {'x': (257.15, 278.15), 'y': (12.5, 31)}
    # Create a Bayesian Optimization object using the custom class
    optimizer = CustomBayesianOptimization(
        f=convergence_dummy,
        acquisition_function=ExplorationAcquisition(),
        #acquisition_function=acquisition.ProbabilityOfImprovement(
        #    xi=0.1,
        #    exploration_decay=0),
        pbounds=pbounds,
        random_state=1
    )

    optimizer.maximize(n_iter=30, init_points="central_points")

    x = [float(res["params"]["x"]) for res in optimizer.res]
    y = [float(res["params"]["y"]) for res in optimizer.res]

    list1 = [(x[i], y[i]) for i in range(len(x))]
    print(list1)
