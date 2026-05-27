# Clip a mesh3d object to an axis-aligned rectangle

Clip a mesh3d object to an axis-aligned rectangle

## Usage

``` r
clip_rect_mesh(mesh, dim_x, dim_y = dim_x, center = c("center", "origin"))
```

## Arguments

- mesh:

  A `mesh3d` object (from the rgl package).

- dim_x:

  Numeric. Edge length along the x-axis.

- dim_y:

  Numeric. Edge length along the y-axis. Defaults to `dim_x` (square).

- center:

  Either a character string `"center"` (geometric center of the mesh's
  xy-extent) or `"origin"` (coordinates `c(0, 0)`), or a numeric vector
  of length 2 giving explicit `c(x, y)` coordinates. Partial matching is
  supported for character inputs.

## Value

A `mesh3d` object containing only vertices within the rectangle and
faces whose vertices all fall within it.
