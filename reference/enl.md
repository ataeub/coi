# Compute the Effective Number of Layers (ENL) for a voxelized point cloud.

Calculates ENL₀, ENL₁, ENL₂ as vertical structural complexity indices.
Optionally plots the vertical voxel distribution.

## Usage

``` r
enl(
  cloud,
  voxel_res = NULL,
  layer_thickness = 1,
  plot = FALSE,
  plot_title = NULL,
  warnings = TRUE
)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- voxel_res:

  Numeric voxel resolution for voxelization.

- layer_thickness:

  Numeric thickness of each vertical layer (default 1).

- plot:

  Logical, whether to plot the vertical voxel distribution (default
  FALSE).

- plot_title:

  Optional character string for the plot title.

- warnings:

  Logical controlling whether to display a warning when voxelization is
  skipped. Defaults to TRUE.

## Value

If plot=FALSE, returns a list (ENL0, ENL1, ENL2). If plot=TRUE, returns
list plus ggplot object.

## Examples

``` r
sphere <- gen_sphere(1, 0.01)
enl_stats <- enl(sphere, voxel_res = 0.05, layer_thickness = 1, plot = TRUE)
```
