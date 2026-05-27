# Save cloud to a .laz file

Converts a cloud in matrix format to a .laz file using the rlas package.

## Usage

``` r
save_to_laz(cloud, file_path)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- file_path:

  Character string specifying the output file path.

## Value

None. Writes a LAZ file to disk.

## Examples

``` r
if (FALSE) { # \dontrun{
  cloud <- gen_sphere(1, 0.3)
  save_to_laz(cloud, "cloud_out.laz")
} # }
```
