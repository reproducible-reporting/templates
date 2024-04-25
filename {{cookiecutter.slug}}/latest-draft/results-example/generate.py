#!/usr/bin/env python3
"""Example data generation script."""

import numpy as np
from stepup.core.script import driver

CASE_FMT = "data_{:02d}"


def cases():
    """Generator over different ways to run this script.

    This is a generator, which yields lists of arguments for reprepbuild_info.
    These cases will be executed in parallel by RepRepBuild (ninja).
    """
    yield 0
    yield 1


def case_info(num):
    """Give RepRep some info on the inputs and outputs to build for case `param`.

    This transforms the simple cases list into a rich dictionary of arguments for main.
    The fields "inputs" and "outputs" are special:
    they are lists of filenames used for dependency tracking.
    """
    return {"shift": num * np.pi / 2, "out": f"data_{num:02d}.txt"}


def run(shift, out):
    """Main data generation program."""
    x = np.linspace(0, 2 * np.pi, 50)
    data = np.array([x, np.cos(x + shift)]).T
    np.savetxt(out, data)


if __name__ == "__main__":
    driver()
