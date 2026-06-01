# Compute a projected 2D crown overlap index for two point clouds.

Calculates the proportion of shared crown footprint in the x-y plane for
two single-tree point clouds.

## Usage

``` r
co_2d(cloud_i, cloud_j, vox_res = NULL, warnings = TRUE)
```

## Arguments

- cloud_i:

  First single tree point cloud as a `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- cloud_j:

  Second single tree point cloud as a `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- vox_res:

  Numeric of the resolution for voxelization during pre-processing. If
  left undefined (default), the raw clouds will be analyzed, which
  should only be done if the clouds have been voxelized before
  independently.

- warnings:

  Logical controlling whether to display a warning when `vox_res` is
  left undefined. Defaults to `TRUE`.

## Value

A numeric representing the projected 2D crown overlap index.

## Details

Takes two raw point clouds representing interacting trees and optionally
voxelizes them to a common resolution. The clouds are then projected to
the x-y plane by dropping z, unique footprint coordinates are extracted
for each tree, and the shared footprint is identified from coordinates
present in both clouds. The returned value is the number of shared
footprint cells divided by the total number of unique footprint cells
across both clouds.

`co_2d()` measures overlap from shared projected x-y coordinates, not
from full 3-D point coincidence. This means crowns can overlap in 2-D
even when they occur at different heights. Because the overlap is
derived from shared footprint coordinates, the function is intended for
voxelized point clouds with a common resolution. The returned index
ranges from 0 for no projected overlap to 1 for identical projected
footprints.

## See also

[`coi()`](https://ataeub.github.io/coi/reference/coi.md) and
[`cci()`](https://ataeub.github.io/coi/reference/cci.md) for related
tree-tree interaction metrics.

## Examples

``` r
sphere1 <- gen_sphere(1, 0.05, c(0, 0, 0))
sphere2 <- gen_sphere(1, 0.05, c(0, 0, 1))
co_2d(sphere1, sphere2, vox_res = 0.05, warnings = FALSE)
#> [1] 1

sphere3 <- gen_sphere(1, 0.05, c(3, 0, 0))
co_2d(sphere1, sphere3, vox_res = 0.05, warnings = FALSE)
#> [1] 0

sphere4 <- gen_sphere(1, 0.05, c(1, 0, 0))
co_2d(sphere1, sphere4, vox_res = 0.05, warnings = FALSE)
#> [1] 0.2436725
```
