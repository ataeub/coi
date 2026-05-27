# Voxelize matrix-like point cloud objects.

This is a simple round-to-multiple function which can be used to
voxelize point clouds.

## Usage

``` r
voxelize(cloud, res)
```

## Arguments

- cloud:

  A `pt_cld` object (see
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)).

- res:

  Numeric of the voxel resolution to apply on the point cloud.

## Value

A `pt_cld` object with the voxelized point cloud.

## Examples

``` r
sphere <- gen_sphere(1, 0.01)
sphere_v <- voxelize(sphere, 0.05)
```
