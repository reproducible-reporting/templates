#!/usr/bin/env python3
"""Example plotting script."""

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# Load our matplotlibrc config. (Not done automagically to keep things clear.)
matplotlib.rc_file("../matplotlibrc")


def reprepbuild_info():
    """Give RepRep some info about inputs and outputs of this script.

    The entire dictionary is passed as keyword arguments to main.
    Feel free to add more fields.
    Just keep in mind that "inputs" and "outputs" are special:
    they are lists of filenames used for dependency tracking.
    """
    return {
        "inputs": ["../dataset-example/example.txt", "data_0.txt", "data_1.txt"],
        "outputs": ["../latex-article/plot-example.pdf"],
    }


def main(inputs, outputs):
    fig, ax = plt.subplots()
    for fn_in in inputs:
        data = np.loadtxt(fn_in)
        ax.plot(data[:, 0], data[:, 1])
    ax.set_title("Usually, you don't need an axes title")
    ax.set_xlabel("x [unit for x]")
    ax.set_ylabel("y [unit for y]")
    fig.savefig(outputs[0])


if __name__ == "__main__":
    main(**reprepbuild_info())
