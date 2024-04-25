#!/usr/bin/env python3
"""Example unit testing script."""

import numpy as np
import pytest
from stepup.core.script import driver

FILENAMES = ["../dataset-example/example.txt", "data_00.txt", "data_01.txt"]


def info():
    """Give Stepup some info about inputs and outputs of this script.

    The entire dictionary is passed as keyword arguments to main.
    Feel free to add more fields.
    Just keep in mind that "inputs" and "outputs" are special:
    they are lists of filenames used for dependency tracking.
    """
    return {"inp": FILENAMES}


@pytest.mark.parametrize("fn_txt", FILENAMES)
def test_shape_txt(fn_txt):
    data = np.loadtxt(fn_txt)
    assert data.ndim == 2
    assert data.shape[0] > 3
    assert data.shape[1] == 2


def run():
    return pytest.main(["-v", __file__])


if __name__ == "__main__":
    driver()
