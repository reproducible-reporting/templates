# Templates documentation

## Before you begin

### Initial competences

The following competences are required (at a basic level) for this template to be useful.

- Unix
- LaTeX
- Git
- Python

Without these competences, it is still possible to contribute to a publication
that uses this template, but it will be difficult to take the lead.


### Required software and configuration

It is assumed that you have installed and configured the following software,
ideally using your operating system's software installation tool
(app store, package manager, pip, ...).

- Git: https://git-scm.com/
- Git LFS: https://git-lfs.com/
- The cookiecutter: https://www.cookiecutter.io/
  (Only needed to initialize a new publication.)
- Inkscape >= 1.2: https://inkscape.org/
  (Only needed when the source contains SVG files.
  [It must be executable as `inkscape` on the command-line](https://stackoverflow.com/a/22085247/494584).)
- TexLive 2021: https://tug.org/texlive/
- A Text editor compatible with [editorconfig](https://editorconfig.org/)

A new dedicated
[pip](https://pip.pypa.io/en/stable/) or [micromamba](https://mamba.readthedocs.io/)
software environment is created for each manuscript.
It is up to each co-author which of the two they prefer:

1. A virtual environment with **pip** can install the dependencies
   with low time, bandwidth and storage overhead.
   You must have a Python version available.
2. A **micromamba** environment (the fastest and lightest way of using conda)
   is a bit more powerful than pip.
   In principle, you can use it on a system without (a decent version of) Python.
   It can also install non_python dependencies.
   The main disadvantage is the time to setup, consumed bandwidth during install, and disk usage.
   Also, the cookiecutter requires Python >= 3.6 to work, so you will need Python when
   initializing a new publication from the template.

The goal is to isolate this software environment from your operating system as much as possible.
However, perfect isolation is not possible yet at this time.
A few points to keep in mind:

- Another always-on pip environment (activated in your shell profile)
  may not work well when pip is used for the publication.

- Similarly, another always-on conda environment (activated in your shell profile)
  may not work well when micromamba is used for the publication.

- Using pip for the publication, on top of your default conda can work well.
  (Needs more testing.)

- When using micromamba, make sure you do not have a `~/.condarc` or `~/.mambarc` file.
  These contain global settings that may interfere with micromamba.

All should work on Linux, macOS and WSL.
It may also work natively on Windows (one day).


## Getting started

You either take route **1a** + **2** or route **1b** + **2**.

### 1) Option a: Start a new publication

- Start a new publication with the [cookiecutter](https://github.com/cookiecutter/cookiecutter):

  ```bash
  cookiecutter https://github.com/reproducible-reporting/templates
  ```

  Follow the instructions on the terminal. You will have to enter:

  - `slug`.
    This a short name for the directory name containing all the sources and compiled outputs.
    Use lower-case characters, digits and hyphens only.
  - `article`.
    The LaTeX article template you want to use.
  - `cover`
    The LaTeX template for the cover letter.

- Enter the newly created directory (`slug`) and initialize the Git repository

  ```bash
  cd 'slug'
  git init
  ```

  where `'slug'` should be replaced with the directory created by the cookiecutter.

- Before making a first commit, define the software requirements,
  e.g. for post-processing and plotting, in `requirements.txt` **AND** `environment.yaml`.
  If you must use micromamba (e.g. non-Python dependencies), then you can remove `requirements.txt`
  and `setup-env-pip.sh`.

- Now you can add all the files, commit them, define a remote URL and push the initial contents online:

  ```bash
  git add .
  git commit -a -m "Initial commit"
  git remote add origin 'remote url'
  git push origin main -u
  ```

  where you replace `'remote url'` by the correct one, which depends on your situation.


### 1) Option b: Clone an existing publication

You need a `'remote url'` of an existing publication.
Substitute this `'remote url'` in the following commands, which should be executed in the terminal:

```bash
git clone 'remote url'
cd 'slug'
```

where `'slug'` should be replaced with the directory created by `git clone`


### 2) Set up the software environment

(It is assumed your current working directory is the `'slug'`
defined in the previous section **1a** or **1b**.)

- Install the software environment, using either **one of the following two** commands (not both):

  ```bash
  ./setup-env-pip.sh
  ./setup-env-micromamba.sh
  ```

- Activate your software environment:

  ```bash
  source env/bin/activate
  ```

  This activation is needed whenever you open a new terminal.
  It is not recommended to add publications-specific activation scripts to your `~/.bashrc`.
  If you find it too tedious to call the activation script over and over again,
  give [`direnv`](https://github.com/direnv/direnv) a try.
  Once `direnv` is installed and configured in your shell profile,
  you only need to allow it once with `direnv allow .`,
  and the `activate` script is automatically loaded when you change to the source directory.

- Install `pre-commit` into the new repository:

  ```bash
  pre-commit install
  ```

  This is needed whenever your create or clone a Git repository.
  (Normally, that is only once per publication.)

- Now you should be able to build the template manuscript and related documents
  with RepRepBuild as follows:

  ```bash
  cd latest-draft
  rr
  ```

When you are editing the source, the command `rrr` can be convenient.
It will continuously rebuild the publication every time you modify a file.

The files generated by `rr` should in general not be committed.
However, there are a few interesting exceptions:

- The files in the `uploads` directory should be committed.
  That makes life easier for co-authors that do not want learn Git (yet).
- Data files with intermediate results, such as CSV tables,
  even when they are computationally cheap, should be committed to Git.
  This may not seem useful, because it should be easy to regenerate them,
  but it still is important.
  With these data files, reproducibility can be verified,
  which is also of interest,
  e.g. when there are issues with the isolation of the software environment,
  or when one tries to reproduce old work for which the software environment is
  difficult to recreate.


## Template conventions

A few conventions are listed in the following subsections.
They are needed for several reasons:

- To make it easy for everyone to find files and work with them.
- To make it possible for RepRepBuild to rebuild the publication efficiently
  (without extensive configuration).
- To make it possible to reproduce the work.

Some of these conventions are imposed and fixed by `pre-commit`.


### General

For file names:

- No whitespace in file and directory names.
- All file and directory names use the ASCII character set.
- Use lowercase filenames, unless you have a very compelling reason not to.
  (Working on the terminal becomes easier when everything is lowercase.)

For text files:

- The UTF-8 character set is always used for the contents.
- No trailing white space, no trailing empty lines.
- Unix end-of-line conventions: `\n`.
- Text files end with a single `\n`.


### Directory layout

For all important versions (submitted, preprint, etc),
a directory `YYYY-MM-DD-description` is created, containing the following:
- `latex-<prefix>/`:
  A LaTeX document, where `<prefix>` can be, e.g., `article`, `si` or `cover`.
  - The file `<prefix>.tex` contains the main LaTeX document.
  - All files needed to compile the LaTeX source should be in the top level directory.
    Do not use subdirectories, because these are not supported on all submission platforms.
  - Each figure must be one file, because some publishers require this.
  - Use PDF or high-resolution PNG files for figures.
  - Also include the sources of the PDF or PNG figures.
    SVG files drawn in Inkscape are converted by `rr` to PDF,
    such that you only need to commit the SVG.
    Figures of plots should not be commited to Git either.
    Commit the scripts to generate these plots instead, as explained below.
- `dataset-<name>`:
  A raw data directory, e.g. used for making plots.
  Always document this file with a `README.md`
  These data are zipped by `rr` for later upload to a data repository.
- `results-<name>`:
  A directory with scripts to generate one or more plots or tables.
  When possible, make multiple of these directories to modularize the post-processing.
- `uploads/`:
  The files uploaded to the publisher, pre-print server and/or data repository.
- `uploads/downloads/`:
  The files for author approval, downloaded from the publisher or pre-print server.

When the source is being edited,
a directory `latest-draft` with the same structure is used,
without a date prefix.
Whenever some relevant milestone is reached, or prior to some drastic change,
a time-stamped copy of `latest-draft` can be made,
named `YYYY-MM-DD-draft-milestone-something`.
Similarly, one may use directories for `submitted`, `revised`, `accepted`, `preprint`, etc.
All directory names with a date prefix are essentially frozen.

One could argue that Git already keeps track of all version.
Nevertheless, having access to all important versions, without going through the revision history,
is convenient, e.g. when making edit traces.
It also lowers the burden for co-authors less proficient with Git.

More details on each directory type can be found in separate `README.md` documents,
which are also copied when you use the cookiecutter:

- `dataset-example/README.md`
- `results-example/README.md`
- `uploads/README.md`
- `uploads/downloads/README.md`


## Usage

### `rr` and `rrr` command-line arguments.

Under the hood, RepRepBuild uses [ninja-build](https://ninja-build.org/) to
rebuild only those files whose dependencies have changed.

Both `rr` and `rrr` are thin wrappers around the `ninja` command.
All command-line arguments are just passed on to `ninja`.

Run `ninja -h` for more details or consult the [Ninja usage documentation](https://ninja-build.org/manual.html#_running_ninja).


### Running parts of the build workflow

You run can `rr target-file`, where `target-file` is the file that needs to be rebuilt.
This will also rebuild dependencies if needed, and will do nothing if the target is already up to date.

Note that execution from within an IDE (PyCharmm, VS, Spider, IDLE, ...) may be tricky.
When trying this, you need to make sure the IDE uses the right software environment and environment variables.
IDEs tend to make abstractions of such details, also hiding potential mistakes.


### Keep clean

- [`pre-commit`](https://pre-commit.com) is used to remove trivial changes,
  which would otherwise result in diff noise.
  Install `pre-commit` and activate it on every clone of the repository.
- To remove all outputs generated by `rr`: `rr -t clean`
- To remove all stale files (defined in `.gitignore`), run `git clean -dfX`.
  Do not use this command before you have committed all important files,
  as it may accidentally remove work in progress.


### Minimal requirements for a pull request

(In the long run, our pre-commit should check for these minimal requirements.)

- Run `rr` after making changes and commit the files in the `uploads` directory.
  Always commit changes to the source together with their result in `uploads`.
  Most intermediate files do not need to be committed to the Git repository,
  unless that seems useful for a clear reason, e.g. computational cost.
- Use meaningful and short commit messages.
- `pre-commit` must pass on each commit.
- Write at least one sentence explaining the pull request on GitHub.


## Policies

This section contains some instructions to facilitate data reuse and reproducibility.

For each section, the core idea is to store as much source material as possible.


### Tex sources

Must:

- All documents are written in LaTeX.
- Every LaTeX package you don't use, is a good package.
- Every sentence starts on a new line in the tex source.
- To facilitate reviewing the PDF, use single-column and double line spacing.
- Use [BibSane](https://github.com/reproducible-reporting/bibsane) to keep your BibTeX files sane.
- Hint: [Quick DOI tot BIB conversion](https://www.doi2bib.org)

Should:

- Some pakcages, like `todo` are convenient while writing.
  Clearly separate these from other `\usepackage` lines, so they can be easily deleted
  when finalizing the manuscript.
- Define as little commands as possible.
- Avoid low-quality publisher article classes. (ACS has a decent one.)


### Figures

Must:

- Separate the data generation or collection from the actual plotting.
  (Do these in two separate Python scripts.)
  This means you commit the following to Git:
  - Data files containing the data shown in the plots.
    Text files like CSV are preferred when possible.
    Also commit these files when the data is auto-generated.
    This may not seems useful, but it allows for verification of reproducibility.
  - Scripts that generate data, if applicable.
  - Scripts to generate the plot, using the above data as input.
    Use matplotlib unless you have good reasons not to.
  - A `README.md` summarizing the scripts and the data.
- When making drawings, use Inkscape (>= 1.2) and commit the SVG source files.
- Use bitmap formats only as an intermediate format when the vector graphics PDF show performance issues.
  This typically happens when a plot contains many thousands of data points.
  Always use PNG as bitmap format.

Things to avoid:

- Jupyter notebooks

### Tables

Must:

- Commit the following:
  - Machine-readable files containing the data shown in the table, e.g. CSV.
  - Scripts to generate the LaTeX source of table.
  - A `README.md` summarizing the scripts and the data.

Things to avoid:

- Jupyter notebooks


### Data sets

Must:

- The `dataset-<name>` directories when appropriate when
  the data cannot be regenerated from scratch,
  or when it would be impractical to do so on a routine basis:
  - External data sets.
  - Super expensive calculations that you carried out separately.
  - Data generated with closed-source software.
    (Avoid closed-source software when you have the choice.)
  - Data generated with specialized hardware not generally available.
  - Manually curated data.
- Use semantic file and directory names to organize your data.
- Add as much as possible scripts and implementations to regenerate the data,
  with exactly the same file and directory names as in the data set.
  Integrate these scripts as much as possible RepRepBuild.
- Add a `README.md` file explaining the following:
  - How was the data computed or collected?
  - Which software + version was used?
  - How are the files and directories organized?
  - If needed, which conventions are used inside the files?
- Data sets are Zipped in the end, so store uncompressed data in the repository.

Should:

- When data sets become large for Git (more than 500 kB), use [Git LFS](https://git-lfs.com/).
  The threshold can be increased for convenience,
  but keep in mind that most remote Git repositories have storage quota.
  For GitHub, the maximum seems to be 5 GB at the moment (for the entire history).
- When data sets become large for Git LFS (more than 50 MB), use University-provided storage.
  Check your Git LFS quota to define a sensible threshold.
  At the time of writing, this is 2 GB (all files combined) for GitHub.
  When offloading data outside the Git repository,
  document clearly where the data is stored, how to access and who has access permissions.
- For some files, e.g. a zipped collection of data files,
  there are no concerns that the zipping itself is difficult to reproduce,
  so you can decide not to store the zip file separately and to add it to `.gitignore` instead.

Things to avoid:

- Jupyter notebooks
- Inventing your own file format.
- Tar files, especially compressed ones.
  These are prone to data loss in case of even the tiniest bit rot.
  Ordinary ZIP is more robust, because every file is compressed individually.
- Compressed files inside compressed files.
- Binary files in general, are harder to reuse in the longer term.
- HDF5 files due to their data integrity issues.
- Python pickle files,
  as these can only be loaded when the corresponding Python packages are around.
  This is too limiting for long-term data preservation.
- Files that can only be used with closed-source software.


### Software

Must:

- List software dependencies in `requirements.txt` or `environment.yaml`,
  such that they can be installed with `pip` or `conda` by all co-authors.
  Specify the version (if relevant).

- All software to rebuild the publication must be open source.

- When you have the choice, do not use closed-source software.

- If you generate some data with closed-source software, store it in a `dataset-<name>`
  directory and document in the `README.md` how you exactly generated the data
  and with which versions of the software.

- If you write your own Python package and use it in a publication,
  make open-source releases of all versions used in the paper.
  In addition to `requirements.txt` or `environment.yaml`,
  also refer to the source repository and the version of your package in the `README.md`
  of the corresponding `results-<name>` or `dataset-<name>` directories.

  If you Python package is highly experimental and you're not comfortable releasing it yet,
  you can include it in the publication repository,
  for example, under `latest-draft/pkgs/your_package`.
  You can then add a line `-e latest-draft/pkgs/your_package`
  to the `requirements.txt` and `environment.yaml` files as follows:

  **requirements.txt** (just add a line)
  ```
  -e ../../reprepbuild
  ```

  **environment.yaml** (add a line under the `pip` item)
  ```
  - pip:
    - '-e ../../reprepbuild'
  ```
