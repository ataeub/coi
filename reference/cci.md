# Compute the crown complementarity index (CCI) for two raw single tree point clouds.

Calculate the CCI as described in Williams et al. 2017 in prep.
All-in-one function handling voxelization, and calculation of CCI.

## Usage

``` r
cci(
  cloud_i,
  cloud_j,
  strata_size,
  hull_type = c("concave", "convex"),
  vox_res = NULL,
  warnings
)
```

## Arguments

- cloud_i:

  First single tree point cloud as a matrix-like object.

- cloud_j:

  Second single tree point cloud as a matrix-like object.

- strata_size:

  Numeric of the size of the vertical strata used within the CCI
  algorithm. See Details and Williams et al. 2017.

- hull_type:

  String controlling the type of hull algorithm used to extract the area
  of each stratum. "Concave" (default) and "convex" are possible. See
  Details.

- vox_res:

  Numeric of the resolution for voxelization during pre-processing. If
  left undefined (default), the raw clouds will be analzed, which should
  only be done if the clouds have been voxelized before independently.

- warnings:

  Logical controlling whether to display a warning when vox_res is left
  undefined. Defaults to TRUE.

## Value

A numeric representing the CCI.

## Details

Takes two raw point clouds representing interacting trees and voxelizes
them to a given common point density. Then CCI is computed.

## Examples

``` r
sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
cci(sphere1, sphere2, 0.3, "concave", 0.05)
#> [1] 0.04197531
```
