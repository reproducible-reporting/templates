#!/usr/bin/env python3
"""Example LaTeX Table generation script.

To keep things simple, no other dependencies than NumPy are used.
For more serious tables, you may want to use a specialized package.
Some suggestions:

- pandas has a `DataFrame.to_latex` function.
  https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_latex.html

- The latextable package may be useful too:
  https://github.com/JAEarly/latextable

- The tabulate package can also make LaTeX tables:
  https://github.com/astanin/python-tabulate

- Sometimes it may be useful to generate more complex LaTeX files
  with more than just tables, for which PyLatex may be handy:
  https://github.com/JelteF/PyLaTeX
"""

import numpy as np
from stepup.core.script import driver


def info():
    """Give Stepup some info on the inputs and outputs."""
    return {"inp": "data_00.txt", "out": "../latex-article/table.tex"}


TABLE_TEMPLATE_HEAD = r"""
\begin{tabular}{cc}
    \hline
    $x$ & $y$ \\
    \hline
"""

TABLE_TEMPLATE_FOOT = r"""
    \hline
\end{tabular}
"""


def run(inp, out):
    """Main data generation program."""
    data = np.loadtxt(inp)
    with open(out, "w") as f:
        f.write(TABLE_TEMPLATE_HEAD)
        for x, y in data[:5]:
            f.write(f"    {x:.2f} & {y:.2f} \\\\\n")
        f.write(TABLE_TEMPLATE_FOOT)


if __name__ == "__main__":
    driver()
