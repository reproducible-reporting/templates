#!/bin/bash

# Select template for the article text
if [ "{{ cookiecutter.article }}" == "none" ]; then
    rm -r latest-draft/latex-article
    rm -r latest-draft/latex-si
else
    mv latest-draft/latex-article/article-{{ cookiecutter.article }}.tex latest-draft/latex-article/article.tex
    rm latest-draft/latex-article/article-*.tex
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

# Select environment setup
mv setup-env-{{ cookiecutter.env }}.sh setup-env.sh
rm setup-env-*.sh
