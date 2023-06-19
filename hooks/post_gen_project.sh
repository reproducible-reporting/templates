#!/bin/bash

# Select template for the article text
if [ "{{ cookiecutter.article }}" == "none" ]; then
    rm -r latest-draft/latex-article
else
    mv latest-draft/latex-article/article-{{ cookiecutter.article }}.tex latest-draft/latex-article/article.tex
    rm latest-draft/latex-article/article-*.tex
fi

# Select template for the supporting information or supplementary material
if [ "{{ cookiecutter.supp }}" == "none" ]; then
    rm -r latest-draft/latex-supp
else
    mv latest-draft/latex-supp/supp-{{ cookiecutter.supp }}.tex latest-draft/latex-supp/supp.tex
    rm latest-draft/latex-supp/supp-*.tex
fi

# Select the template for the cover and reply
if [ "{{ cookiecutter.cover }}" == "none" ]; then
    rm -r latest-draft/latex-cover
    rm -r latest-draft/latex-reply
else
    mv latest-draft/latex-cover/cover-{{ cookiecutter.cover }}.tex latest-draft/latex-cover/cover.tex
    rm latest-draft/latex-cover/cover-*.tex
    mv latest-draft/latex-reply/reply-{{ cookiecutter.cover }}.tex latest-draft/latex-reply/reply.tex
    rm latest-draft/latex-reply/reply-*.tex
fi
