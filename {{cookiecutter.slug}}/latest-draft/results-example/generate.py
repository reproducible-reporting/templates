#!/usr/bin/env python3
"""Example data generation script."""

import numpy as np

REPREPBUILD_CASE_FMT = "data_{:02d}"


def reprepbuild_cases():
    """Generator over different ways to run this script.

    This is a generator, which yields lists of arguments for reprepbuild_info.
    These cases will be executed in parrallel by RepRepBuild (ninja).
    """
    yield [0]
    yield [1]


def reprepbuild_info(case):
    """Give RepRep some info on the inputs and outputs to build for case `param`.

    This transforms the simple cases list into a rich dictionary of arguments for main.
    The fields "inputs" and "outputs" are special:
    they are lists of filenames used for dependency tracking.
    """
    return {"shift": case * np.pi / 2, "outputs": [f"data_{case:02d}.txt"]}


def main(shift, outputs):
    """Main data generation program."""
    x = np.linspace(0, 2 * np.pi, 50)
    data = np.array([x, np.cos(x + shift)]).T
    np.savetxt(outputs[0], data)


if __name__ == "__main__":
    for build_case in reprepbuild_cases():
        main(**reprepbuild_info(*build_case))
