"""
Test-module for functions and classes concerning the building models
"""
import json
import pathlib
import unittest
from pathlib import Path

import numpy as np

from bes_rules.utils.multiprocessing_ import execute_function_in_parallel


def foo(x: int, y: int):
    return x*y


class TestUtils(unittest.TestCase):
    """Test-retrofit temperatures."""

    def test_mp(self):
        func_kwargs = [{"x": i, "y": i * 0.5} for i in range(100)]
        returns_1 = execute_function_in_parallel(foo, func_kwargs, n_cpu=1)
        returns_2 = execute_function_in_parallel(foo, func_kwargs, n_cpu=2)
        returns_all = execute_function_in_parallel(foo, func_kwargs)
        returns_all_no_mp = execute_function_in_parallel(foo, func_kwargs, use_mp=False)
        self.assertEqual(returns_1, returns_2)
        self.assertEqual(returns_1, returns_all)
        self.assertEqual(returns_1, returns_all_no_mp)
        returns_2 = execute_function_in_parallel(foo, func_kwargs, n_cpu=2, notifier=print)
        self.assertEqual(returns_1, returns_2)


if __name__ == "__main__":
    unittest.main()
