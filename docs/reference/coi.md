# Compute the crown overlap index (COI) for two raw single tree point clouds.

Calculate the COI as described in Täuber et al. (in prep.) All-in-one
function handling voxelization, interaction extraction, and calculation
of COI.

## Usage

``` r
coi(cloud_i, cloud_j, d_max, vox_res = NULL, warnings = TRUE)
```

## Arguments

- cloud_i:

  First single tree point cloud as a `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- cloud_j:

  Second single tree point cloud as a `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- d_max:

  Numeric of the maximum distance of interaction. Decides how far away
  points of one tree can be from the other before they are excluded from
  the interaction cloud.

- vox_res:

  Numeric of the resolution for voxelization during pre-processing. If
  left undefined (default), the raw clouds will be analzed, which should
  only be done if the clouds have been voxelized before independently.

- warnings:

  Logical controlling whether to display a warning when vox_res is left
  undefined. Defaults to TRUE.

## Value

A numeric representing the COI.

## Details

Takes two raw point clouds representing interacting trees and voxelizes
them to a given common point density. Then the interaction (overlap) of
the clouds is extracted according to the maximum distance parameter.
Finally from this interaction cloud the COI is computed. This is a
convenience function doing all preprocessing for COI calculation in one
function. You may want to inspect the interaction clouds before COI
computation or save them as seperate files. For this the low-level
function
[`compute_coi()`](https://ataeub.github.io/coi/reference/compute_coi.md)
is available.

## Examples

``` r
sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
coi(sphere1, sphere2, 0.3, 0.05)
#> [1] 0.7794753
```
