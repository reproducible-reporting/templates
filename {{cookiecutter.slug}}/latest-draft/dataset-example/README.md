# Dataset "Example"

(All sentences between parenthesis can be removed eventually.)
(Replace "Example" by something more meaningful.)

## Data descriptor

(Write out the information in the following sections in detail.)

### How the data were generated

Give step-by-step instruction explaining how you obtained the data.
This section must be reproducible.

### Software that was used

Complete list with versions, specific to this data set.

### Directory and file organization

Explain the meaning of directory and file names.
Use names that are easy to explain.

### File content details

When using "unstructured" formats, e.g. CSV, YAML, JSON,
document the conventions in those files or refer to such documentation.


## Suggestions

This entire section can be removed.
When you have the freedom to select the file format, consider one of the following:

- **CSV**:
  This format will remain readable for the foreseeable future.
  It is useful for tabulated data (rows and columns).
  See [`pandas`](https://pandas.pydata.org/).
- **Zarr** or **netCDF**:
  These formats are convenient for higher-dimensional data.
  The main downside is that these formats are binary.
  See [`xarray`](https://docs.xarray.dev/en/stable/index.html).
- **JSON**:
  This is good for unstructured data,
  in which case you need to document the structure in the sections above.
- **YAML**:
  Similar to JSON, but mainly useful for manual input of data.
  See [`pyyaml`](https://pypi.org/project/PyYAML/)
