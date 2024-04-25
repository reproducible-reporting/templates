#!/usr/bin/env python3
"""Example plotting script."""

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from stepup.core.script import driver


def info():
    """Give RepRep some info about inputs and outputs of this script.

    The entire dictionary is passed as keyword arguments to main.
    Feel free to add more fields.
    Just keep in mind that "inputs" and "outputs" are special:
    they are lists of filenames used for dependency tracking.
    """
    return {
        "inp": [
            "../matplotlibrc",
            "../dataset-example/example.txt",
            "data_00.txt",
            "data_01.txt",
        ],
        "out": "../latex-article/plot-example.pdf",
    }


def run(inp, out):
    matplotlib.rc_file(inp.pop(0))
    fig, ax = plt.subplots()
    for fn_in in inp:
        data = np.loadtxt(fn_in)
        ax.plot(data[:, 0], data[:, 1])
    ax.set_title("Usually, you don't need an axes title")
    ax.set_xlabel("x [unit for x]")
    ax.set_ylabel("y [unit for y]")
    fig.savefig(out)


if __name__ == "__main__":
    driver()
