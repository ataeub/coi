# Compute canopy height statistics from a point cloud.

Calculate various canopy height statistics from a point cloud rasterized
to a grid. The cloud is snapped to a regular grid and the maximum height
per cell is extracted. Statistics are computed for heights above a given
threshold.

## Usage

``` r
canopy_stats(cloud, res, lower_cutoff = NULL, plot = FALSE, plot_title = NULL)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- res:

  Numeric of the grid resolution for rasterization.

- lower_cutoff:

  Numeric of the minimum canopy height threshold. Heights below this
  value are excluded from statistics calculation.

- plot:

  Logical controlling whether to plot the rasterized canopy height grid.
  Defaults to FALSE.

- plot_title:

  Character string for the plot title. Only used when `plot = TRUE`.
  Defaults to "Canopy Height Raster".

## Value

A list with elements "max", "mean", "sd", "cv" (coefficient of
variation), "gini" (Gini coefficient), "openness" (proportion of NA
cells in the raster grid as a value between 0 and 1), and "grid" (the
rasterized height matrix). If `plot = TRUE`, an additional "plot"
element containing a ggplot object is included. The plot legend title
displays the canopy statistics using HTML-formatted text via `ggtext`.

## Examples

``` r
if (FALSE) { # \dontrun{
sphere <- gen_sphere(1, 0.01)
stats <- canopy_stats(sphere, res = 0.1, lower_cutoff = 0.5, plot = FALSE)
} # }
```
