#!/usr/bin/env python3
from path import Path
from stepup.core.api import copy, glob, script, static
from stepup.reprep.api import (
    compile_latex,
    convert_inkscape_pdf,
    diff_latex,
    flatten_latex,
    make_inventory,
    sanitize_bibtex,
    wrap_git,
    zip_inventory,
)

# Zip dataset
static("dataset-example/")
make_inventory(*glob("dataset-example/*.*"), "dataset-example-inventory.txt")
zip_inventory("dataset-example-inventory.txt", "uploads/dataset-example.zip")

# Python scripts in results-*/
static("matplotlibrc")
for script_path in static("results-*/*.py"):
    script(script_path.name, workdir=script_path.parent)

# Write some information of the Git commit to in include file:
static("../.git/")
wrap_git("git log -n 1 --pretty='format:%cs (%h)' --date=short", stdout="git-info.txt")

# Convert SVG to PDF figures
for path_svg in static("*/*.svg"):
    convert_inkscape_pdf(path_svg, optional=True)

# Declare static directories and files for LaTeX documents
static("bibsane.yaml")

# Compile LaTeX documents
for m in glob("latex-${*name}/${*name}.tex"):
    static(m.single)
    # Clean up the bib file if present
    path_bib = f"latex-{m.name}/references.bib"
    if glob(path_bib):
        static(path_bib)
        sanitize_bibtex(
            path_bib,
            path_aux=f"latex-{m.name}/{m.name}.aux",
            path_cfg="bibsane.yaml",
            overwrite=True,
        )

    # Identify the Tex source files and PNGs
    do_flatten = len(static(f"latex-{m.name}/[0-9][0-9]-*.tex")) > 0
    static(f"latex-{m.name}/*.png")
    if do_flatten:
        path_main = f"latex-{m.name}/{m.name}-flat.tex"
        flatten_latex(
            f"latex-{m.name}/{m.name}.tex",
            path_main,
        )
    else:
        path_main = f"latex-{m.name}/{m.name}.tex"

    # Compile the document and copy the PDF to uploads.
    info = compile_latex(
        f"{m.name}.tex",
        workdir=f"latex-{m.name}/",
        inventory=True,
    )
    path_pdf = info.filter_out("*.pdf").single()
    copy(info.workdir / path_pdf, f"uploads/{m.name}.pdf")

    # Create a diff, compile it and copy the PDF to uploads.
    path_old_tex = f"latex-{m.name}/{m.name}-old.tex"
    if glob(path_old_tex):
        static(path_old_tex)
        path_diff_tex = Path(f"latex-{m.name}/{m.name}-diff.tex")
        diff_latex(
            path_old_tex,
            path_main,
            path_diff_tex,
        )
        path_old_bbl = f"latex-{m.name}/{m.name}-old.bbl"
        if glob(path_old_bbl):
            static(path_old_bbl)
            diff_latex(
                path_old_bbl,
                f"latex-{m.name}/{m.name}.bbl",
                f"latex-{m.name}/{m.name}-diff.bbl",
            )
        info_diff = compile_latex(
            path_diff_tex.name,
            run_bibtex=False,
            workdir=f"latex-{m.name}/",
            inventory=True,
        )
        path_pdf_diff = info_diff.filter_out("*.pdf").single()
        copy(info_diff.workdir / path_pdf_diff, "uploads/")
