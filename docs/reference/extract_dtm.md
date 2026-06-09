# Extract digital terrain model from point cloud

Extracts a digital terrain model (DTM) mesh from a point cloud by
computing the minimum Z value within each grid cell and triangulating
the result.

## Usage

``` r
extract_dtm(
  cloud,
  res,
  sm_type = NULL,
  sm_i = NULL,
  sm_lambda = NULL,
  sm_mu = NULL,
  sm_delta = NULL
)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- res:

  (numeric) Grid cell resolution for DTM extraction. Determines the
  spacing of ground points in the resulting mesh.

- sm_type:

  (character) Smoothing algorithm type; passed to `Rvcg::vcgSmooth()`.
  Options include "taubin", "laplace", "fuhrmann", etc. Default: NULL

- sm_i:

  (integer) Number of smoothing iterations. Default: NULL

- sm_lambda:

  (numeric) Smoothing lambda parameter. Default: NULL

- sm_mu:

  (numeric) Smoothing mu parameter. Default: NULL

- sm_delta:

  (numeric) Smoothing delta parameter. Default: NULL

## Value

(mesh3d) A 3D mesh object representing the DTM surface, suitable for use
with
[`z_normalize()`](https://ataeub.github.io/coi/reference/z_normalize.md)
or visualization with
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).

## Details

The function divides the point cloud into a regular grid based on the
resolution parameter, extracts the minimum Z value (ground elevation)
for each cell, and creates a Delaunay triangulation mesh from these
ground points. Optional smoothing can be applied to the resulting mesh
using various smoothing algorithms.

## Examples

``` r
if (FALSE) { # \dontrun{
cloud <- gen_sphere(50, 1)
dtm <- extract_dtm(cloud, res = 2)
# Visualize the DTM
rgl::shade3d(dtm, col = "gray")
} # }
```
