# Template for Archive README

Feel free to remove the following instructions after completing them:

> It is recommended to first read the tutorial on archiving [Git-hosted StepUp RepRep projects](TODO).
>
> This is a template for describing arhived copies of the repository.
> You can modify this README and [`create_archives.sh`](create_archives.sh)
> to prepare to archival of the repository:
>
> - Choose suitable filenames for the archives.
> - Add a brief description for each archive.
> - Explain how to unpack each archive.
> - Estimate how long the archives should be preserved.
> - Describe where the data will be archived
>
> After finalizing these preparations, do the following:
>
> - Copy or upload archives and this README to their final destination.
> - Store this README in a searchable metadata repository.

The archives below were created by running [`create_archives.sh`](create_archives.sh) in this `archives` directory:

```bash
./create_archives.sh
```

### `main.bundle`: complete history of the repository source files in the `main` branch

This file can be unpacked with the following command:

```bash
git clone main.bundle
```

### `main-latest-with-outputs.zip`: latest version on `main` branch with build outputs.

This zip file can be unpacked as follows:

```bash
unzip main-latest-with-outputs.zip
```

When you do this on a Unix machine, file permissions will be preserved.
