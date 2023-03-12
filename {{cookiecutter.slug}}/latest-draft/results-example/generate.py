#!/usr/bin/env python3
"""Example data generation script."""


def reprepbuild_info():
    """Give RepRep some info about inputs and outputs of this script."""
    return {
        "inputs": [],
        "outputs": ["generated.txt"],
    }


def main():
    # Seems ugly, but will speed things up.
    # It allows reprepbuild_info to be called without waiting for these imports.
    import numpy as np

    x = np.linspace(0, 2 * np.pi, 50)
    data = np.array([x, np.sin(x), np.cos(x)]).T
    np.savetxt("generated.txt", data)
