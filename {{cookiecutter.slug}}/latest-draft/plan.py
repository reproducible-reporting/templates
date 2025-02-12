#!/usr/bin/env python3
from stepup.core.api import copy, glob, script, static
from stepup.reprep.api import (
    compile_latex,
    convert_inkscape_pdf,
    diff_latex,
    flatten_latex,
    make_inventory,
    sanitize_bibtex,
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
    script(f"{m.script}.py", workdir=f"results-{m.name}/")

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
    convert_inkscape_pdf(path_svg, optional=True)

# Prepare the latex-article/article.tex
if glob("latex-article/article-structured.tex"):
    # If using \input and related commands, write the source in article-structured.tex
    flatten_latex("latex-article/article-structured.tex", "latex-article/article.tex")
else:
    # Write just article.tex in case of a single file source.
    static("latex-article/article.tex")

# Compile LaTeX documents
for m in latex_dirs:
    latexbin = "xelatex" if m.name == "presentation" else "pdflatex"
    info = compile_latex(
        f"{m.name}.tex",
        latex=latexbin,
        workdir=f"latex-{m.name}/",
        inventory=(m.name in ["article", "supp"]),
    )
    if len(info.filter_inp("*.bib").files()) > 1:
        sanitize_bibtex(f"latex-{m.name}/{m.name}.aux", path_cfg="bibsane.yaml")
    path_pdf = info.filter_out("*.pdf").single()
    copy(info.workdir / path_pdf, "uploads/")

# Create ZIP files with LaTeX sources
for name in "article", "supp":
    zip_inventory(f"latex-{name}/{name}-inventory.txt", f"uploads/{name}.zip")

# If there is an old version, Compile the LaTeX diff into a PDF.
if glob("latex-article/old/"):
    static("latex-article/old/article.tex")
    diff_latex(
        "latex-article/old/article.tex",
        "latex-article/article.tex",
        "latex-article/article-diff.tex",
    )
    if glob("latex-article/old/article.bbl"):
        diff_latex(
            "latex-article/old/article.bbl",
            "latex-article/article.bbl",
            "latex-article/article-diff.bbl",
        )
    info = compile_latex("article-diff.tex", run_bibtex=False, workdir="latex-article/")
    path_pdf = info.filter_out("*.pdf").single()
    copy(info.workdir / path_pdf, "uploads/")
