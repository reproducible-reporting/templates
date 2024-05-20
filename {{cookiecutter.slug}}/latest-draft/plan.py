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

static("bibsane.yaml")
static("dataset-example/")
static("dataset-example/inventory.def")
static("dataset-example/example.txt")
latex_dirs = glob("latex-${*name}/")
static("latex-article/references.bib")
static("latex-cover/cover.tex")
static("latex-reply/reply.tex")
static("latex-presentation/presentation.tex")
static("latex-presentation/pexels-mathias-reding-5838235.jpg")
static("latex-supp/supp.tex")
glob("results-*/")
static("matplotlibrc")
static("uploads/")

for path_svg in glob("*/*.svg"):
    convert_svg_pdf(path_svg, optional=True)

for m in glob("results-${*name}/${*script}.py"):
    script(f"{m.script}.py", f"results-{m.name}/")

if glob("latex-article/article-structured.tex"):
    latex_flat("latex-article/article-structured.tex", "latex-article/article.tex")
else:
    static("latex-article/article.tex")

for m in latex_dirs:
    latexbin = "xelatex" if m.name == "presentation" else "pdflatex"
    path_pdf = latex(
        f"{m.name}.tex",
        latex=latexbin,
        workdir=f"latex-{m.name}/",
        bibsane_config="../bibsane.yaml",
    )
    copy(path_pdf, "uploads/")

for name in "article", "supp":
    zip_inventory(f"latex-{name}/{name}-inventory.txt", f"uploads/{name}.zip")

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

static("dataset-example/")
make_inventory(glob("dataset-example/*.*"), "dataset-example-inventory.txt")
zip_inventory("dataset-example-inventory.txt", "uploads/dataset-example.zip")
