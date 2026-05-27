# Convert tabular data to a point cloud matrix

`cloud_to_mat()` is deprecated. Use
[`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md) or
[`pt_cld()`](https://ataeub.github.io/coi/reference/pt_cld.md) instead,
which return a proper `pt_cld` class object.

## Usage

``` r
cloud_to_mat(input, which = "xyz")
```

## Arguments

- input:

  Any tabular data representing a point cloud.

- which:

  A string to decide which point columns the function returns. Consists
  of the 1 to 3 characters "x", "y", or "z". Defaults to "xyz" returning
  all columns.

## Value

A `pt_cld` object (when `which = "xyz"`) or a matrix subset.

## Examples

``` r
sphere <- gen_sphere(1, 0.05)
sphere <- as.data.frame(sphere)
cloud <- as_pt_cld(sphere)
```
