# Clip a point cloud to an axis-aligned rectangle

Clip a point cloud to an axis-aligned rectangle

## Usage

``` r
clip_rect(cloud, dim_x, dim_y = dim_x, center = c("center", "origin"))
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- dim_x:

  Numeric. Edge length along the x-axis.

- dim_y:

  Numeric. Edge length along the y-axis. Defaults to `dim_x` (square).

- center:

  Either a character string `"center"` (geometric center of the cloud's
  xy-extent) or `"origin"` (coordinates `c(0, 0)`), or a numeric vector
  of length 2 giving explicit `c(x, y)` coordinates. Partial matching is
  supported for character inputs.

## Value

A `pt_cld` object containing only points within the specified rectangle.

## Examples

``` r
cloud <- gen_sphere(20, 0.5)
cloud_clipped <- clip_rect(cloud, dim_x = 5, dim_y = 6, center = "center")
min(cloud_clipped[, "x"])
#> [1] -2.5
max(cloud_clipped[, "y"])
#> [1] 3
```
