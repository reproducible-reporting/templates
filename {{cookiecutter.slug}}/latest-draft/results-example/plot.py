#!/usr/bin/env python3
"""Example plotting script."""

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# Load our matplotlibrc config. (Not done automagically to keep things clear.)
matplotlib.rc_file("../matplotlibrc")


def reprepbuild_info():
    """Give RepRep some info about inputs and outputs of this script."""
    return {
        "inputs": ["../dataset-example/example.txt", "generated.txt"],
        "outputs": ["../latex-article/plot-example.pdf"],
    }


def main():
    data_ext = np.loadtxt("../dataset-example/example.txt")
    data_int = np.loadtxt("generated.txt")

    fig, ax = plt.subplots()
    ax.plot(data_int[:, 0], data_int[:, 1])
    ax.plot(data_int[:, 0], data_int[:, 2])
    ax.plot(data_ext[:, 0], data_ext[:, 1])
    ax.set_title("Usually, you don't need an axes title")
    ax.set_xlabel("x [1]")
    ax.set_ylabel("y [1]")
    fig.savefig("../latex-article/plot-example.pdf")


if __name__ == "__main__":
    main()
