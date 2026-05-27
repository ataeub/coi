# Compute the box dimension structural complexity index for a given point cloud.

Calculate the box dimension as described in Seidel et al. (2018)

## Usage

``` r
boxdim(
  cloud,
  threshold,
  vox_res = NULL,
  plot = FALSE,
  plot_title = NULL,
  warnings = TRUE
)
```

## Arguments

- cloud:

  A `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- threshold:

  The lower resolution threshold until which the box dimension algorithm
  iterates

- vox_res:

  Numeric of the resolution for voxelization. If left undefined
  (default), the raw cloud will be analzed, which should only be done if
  the cloud has been voxelized before independently.

- plot:

  Logical. If TRUE, a ggplot of the log-log regression is included in
  the output. Defaults to FALSE.

- plot_title:

  Optional character string for the plot title.

- warnings:

  Logical controlling whether to display a warning when vox_res is left
  undefined. Defaults to TRUE.

## Value

If `plot = FALSE` (default), a numeric representing the box dimension.
If `plot = TRUE`, a named list with elements `boxdim` (the box
dimension) and `plot` (a ggplot object).

## Examples

``` r
sphere <- gen_sphere(1, 0.01, c(0, 0, 0))
boxdim(sphere, 0.1, 0.05)
#> [1] 2.406308
```
