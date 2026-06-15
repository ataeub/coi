# Compute the crown overlap index (COI) for a vector with interaction distances.

Calculate the COI as described in Täuber et al. (in prep.) Bare
calculation fcunction requiring interaction distanes pre-computed with
[`extract_interaction()`](https://ataeub.github.io/coi/reference/extract_interaction.md).
For an all-in-one function you can use on raw single tree point clouds
use [`coi()`](https://ataeub.github.io/coi/reference/coi.md).

## Usage

``` r
compute_coi(distances, size_weight, d_max)
```

## Arguments

- distances:

  Vector with interaction distances.

- size_weight:

  Numeric of the size (Number of points/voxels) of both clouds from
  which the interaction distances were computed.

- d_max:

  Numeric of the maximum distance of interaction used to extract the
  interaction distances with
  [`extract_interaction()`](https://ataeub.github.io/coi/reference/extract_interaction.md).
  Set to 0 if only exact point or voxel matches should contribute to the
  COI. When `d_max = 0`, an all-zero interaction vector is treated as
  valid and does not trigger a warning.

## Value

Numeric representing the COI.

## Details

Takes a vector with the distances of an interaction point cloud of two
voxelized single tree point clouds, the size of the sum of clouds, and
the maximum distance parameter used to compute said interaction vector
and calculates the COI from it.

## Examples

``` r
sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
sphere1_v <- voxelize(sphere1, 0.05)
sphere2_v <- voxelize(sphere2, 0.05)
sphere1_v_size <- nrow(sphere1_v)
sphere2_v_size <- nrow(sphere2_v)
size_total <- sum(sphere1_v_size, sphere2_v_size)
d_max <- 0.3
i_dists <- extract_interaction(sphere1_v, sphere2_v, d_max)
compute_coi(i_dists, size_total, d_max)
#> [1] 0.7794753
```
