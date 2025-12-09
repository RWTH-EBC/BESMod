import unittest
from custom_bayes import CustomBayesianOptimization
from bayes_opt import acquisition
import numpy as np
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern


class BayesianOptTestCase(unittest.TestCase):

    def test_initialization(self):
        def convergence_dummy(x, y):
            return 1 * y ** 2 + 2 * y + 0.5 * x + 2000

        pbounds1 = {'x': (0, 2), 'y': (0, 2)}
        pbounds2 = {'x': (-2, 2), 'y': (-2, 2)}
        pbounds3 = {'x': (257.15, 278.15), 'y': (12.5, 31)}

        optimizer1 = CustomBayesianOptimization(f=convergence_dummy, pbounds=pbounds1)
        optimizer1.maximize(n_iter=0, initialization_method='central_points')

        optimizer2 = CustomBayesianOptimization(f=convergence_dummy, pbounds=pbounds2)
        optimizer2.maximize(n_iter=0, initialization_method='central_points')

        optimizer3 = CustomBayesianOptimization(f=convergence_dummy, pbounds=pbounds3)
        optimizer3.maximize(n_iter=0, initialization_method='central_points')

        x1 = [float(res["params"]["x"]) for res in optimizer1.res]
        y1 = [float(res["params"]["y"]) for res in optimizer1.res]

        x2 = [float(res["params"]["x"]) for res in optimizer2.res]
        y2 = [float(res["params"]["y"]) for res in optimizer2.res]

        x3 = [float(res["params"]["x"]) for res in optimizer3.res]
        y3 = [float(res["params"]["y"]) for res in optimizer3.res]

        initialization_points_testing1 = [(0.0, 0.0), (0.0, 1.0), (0.0, 2.0), (1.0, 0.0), (1.0, 1.0), (1.0, 2.0),
                                          (2.0, 0.0), (2.0, 1.0),
                                          (2.0, 2.0)]
        initialization_points_testing2 = [(2.0, -2.0), (-2.0, -2.0), (0.0, 0.0), (2.0, 0.0), (-2.0, 0.0), (0.0, 2.0),
                                          (2.0, 2.0), (-2.0, 2.0), (0.0, -2.0)]
        initialization_points_testing3 = [(257.15, 31.0), (267.65, 12.5), (267.65, 31.0), (278.15, 21.75),
                                          (267.65, 21.75), (257.15, 21.75),
                                          (278.15, 12.5), (257.15, 12.5), (278.15, 31.0)]

        initialization_points1 = [(x1[i], y1[i]) for i in range(9)]
        initialization_points2 = [(x2[i], y2[i]) for i in range(9)]
        initialization_points3 = [(x3[i], y3[i]) for i in range(9)]

        self.assertCountEqual(initialization_points1, initialization_points_testing1)  # add assertion here
        self.assertCountEqual(initialization_points2, initialization_points_testing2)  # add assertion here
        self.assertCountEqual(initialization_points3, initialization_points_testing3)  # add assertion here

    def test_surrogate(self):
        def convergence_dummy(x, y):
            return 1 * y ** 2 + 2 * y + 0.5 * x + 2000

        pbounds = {'x': (-10, 10), 'y': (-10, 10)}

        optimizer = CustomBayesianOptimization(
            f=convergence_dummy,
            pbounds=pbounds,
            acquisition_function=acquisition.ProbabilityOfImprovement(xi=0.1, exploration_decay=0),
            random_state=1
        )

        optimizer._gp = GaussianProcessRegressor(
            kernel=Matern(nu=2.5, length_scale=[2000, 30]),
            optimizer=None, )
        optimizer.maximize(n_iter=21, initialization_method="central_points")

        x_range = np.linspace(-10, 10, 100)
        y_range = np.linspace(-10, 10, 100)
        X, Y = np.meshgrid(x_range, y_range)

        grid = np.vstack([X.ravel(), Y.ravel()]).T
        print(optimizer._gp)
        mean, sigma = optimizer._gp.predict(grid, return_std=True)

        mean = mean.reshape(X.shape)
        sigma = sigma.reshape(X.shape)

        true_values = np.array([convergence_dummy(x, y) for x, y in grid])
        true_values = true_values.reshape(X.shape)

        # Calculate mean absolute error
        mae = np.mean(np.abs(mean - true_values))
        print(mae)

        self.assertLess(mae, 0.5)


if __name__ == '__main__':
    unittest.main()

