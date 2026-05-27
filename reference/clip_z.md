# Clip point cloud vertically

Removes points from the top or bottom of a point cloud along the Z-axis,
preserving the remaining vertical slice.

## Usage

``` r
clip_z(cloud, length, from_top = FALSE)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- length:

  (numeric) The length (in Z units) to remove from the cloud.

- from_top:

  (logical) If TRUE, remove from top; if FALSE, remove from bottom.
  Default: FALSE

## Value

A `pt_cld` object with the clipped point cloud.

## Details

The function uses the `from_top` parameter to determine the clipping
direction: if `from_top = TRUE`, points are removed from the top of the
cloud (above max_z - length); if `from_top = FALSE`, points are removed
from the bottom (below min_z + length). This is useful for removing
canopy or ground points when focusing on a specific height range.

## Examples

``` r
cloud <- gen_sphere(50, 1)
# Remove bottom 5 units
clipped_bottom <- clip_z(cloud, 5, from_top = FALSE)
# Remove top 5 units
clipped_top <- clip_z(cloud, 5, from_top = TRUE)
```
