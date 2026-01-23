# Voxelize matrix-like point cloud objects.

This is a simple round-to-multiple function which can be used to
voxelize point clouds.

## Usage

``` r
voxelize(cloud, res)
```

## Arguments

- cloud:

  The point cloud to voxelize as a matrix-like object.

- res:

  Numeric of the voxel resolution to apply on the point cloud.

## Value

The voxelized point cloud as a matrix with columns "x", "y", "z".

## Examples

``` r
sphere <- gen_sphere(1, 0.01)
sphere_v <- voxelize(sphere, 0.05)
```
