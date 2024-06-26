#!/usr/bin/env python
from stepup.core.api import copy, glob, script, static
from stepup.reprep.api import (
    convert_svg_pdf,
    latex,
    latex_diff,
    latex_flat,
    make_inventory,
    zip_inventory,
)

# The upload directory will hold the important artifacts.
static("uploads/")

# Zip dataset
static("dataset-example/")
make_inventory(glob("dataset-example/*.*"), "dataset-example-inventory.txt")
zip_inventory("dataset-example-inventory.txt", "uploads/dataset-example.zip")

# Python scripts in results-*/
glob("results-*/")
static("matplotlibrc")
for m in glob("results-${*name}/${*script}.py"):
    script(f"{m.script}.py", f"results-{m.name}/")

# Declare static directories and files for LaTeX documents
static("bibsane.yaml")
latex_dirs = glob("latex-${*name}/")
static("latex-article/references.bib")
static("latex-cover/cover.tex")
static("latex-reply/reply.tex")
static("latex-presentation/presentation.tex")
static("latex-presentation/pexels-mathias-reding-5838235.jpg")
static("latex-supp/supp.tex")

# Convert SVG to PDF figures
for path_svg in glob("*/*.svg"):
    convert_svg_pdf(path_svg, optional=True)

# Prepare the latex-article/article.tex
if glob("latex-article/article-structured.tex"):
    # If using \input and related commands, write the source in article-structured.tex
    latex_flat("latex-article/article-structured.tex", "latex-article/article.tex")
else:
    # Write just article.tex in case of a single file source.
    static("latex-article/article.tex")

# Compile LaTeX documents
for m in latex_dirs:
    latexbin = "xelatex" if m.name == "presentation" else "pdflatex"
    path_pdf = latex(
        f"{m.name}.tex",
        latex=latexbin,
        workdir=f"latex-{m.name}/",
        bibsane_config="../bibsane.yaml",
    )
    copy(path_pdf, "uploads/")

# Create ZIP files with LaTeX sources
for name in "article", "supp":
    zip_inventory(f"latex-{name}/{name}-inventory.txt", f"uploads/{name}.zip")

# If there is an old version, Compile the LaTeX diff into a PDF.
if glob("latex-article/old/"):
    static("latex-article/old/article.tex")
    latex_diff(
        "latex-article/old/article.tex",
        "latex-article/article.tex",
        "latex-article/article-diff.tex",
    )
    if glob("latex-article/old/article.bbl"):
        latex_diff(
            "latex-article/old/article.bbl",
            "latex-article/article.bbl",
            "latex-article/article-diff.bbl",
        )
    path_pdf = latex("article-diff.tex", run_bibtex=False, workdir="latex-article/")
    copy(path_pdf, "uploads/")
