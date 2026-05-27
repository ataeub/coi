# Generate an artifical voxelized point cloud of a sphere.

Generate an artifical voxelized point cloud of a sphere.

## Usage

``` r
gen_sphere(r, res, center = c(0, 0, 0))
```

## Arguments

- r:

  Numeric of the radius of the sphere.

- res:

  Numeric of the voxel resolution of the cloud.

- center:

  Three element vector (x, y, z) of the center point of the cloud.

## Value

A `pt_cld` object.

## Examples

``` r
# Generate 1 meter sphere with 5 cm voxel resolution at center (1,2,3)
sphere <- gen_sphere(1, 0.05, c(1, 2, 3))
```
