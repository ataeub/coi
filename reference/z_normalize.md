# Normalize point cloud to digital terrain model

Normalizes a point cloud by computing a digital terrain model (DTM) mesh
and calculating the normalized Z coordinates for each point based on its
elevation relative to the DTM surface.

## Usage

``` r
z_normalize(
  cloud,
  res = NULL,
  dtm = NULL,
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

  (numeric) Resolution parameter for DTM mesh extraction. Ignored if
  `dtm` is provided. Default: NULL

- dtm:

  (mesh3d object) Pre-computed DTM mesh object. If provided, `res` and
  smoothing parameters are ignored. Default: NULL

- sm_type:

  (character) Smoothing type; passed to
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).
  Default: NULL

- sm_i:

  (integer) Smoothing iterations; passed to
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).
  Default: NULL

- sm_lambda:

  (numeric) Smoothing lambda parameter; passed to
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).
  Default: NULL

- sm_mu:

  (numeric) Smoothing mu parameter; passed to
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).
  Default: NULL

- sm_delta:

  (numeric) Smoothing delta parameter; passed to
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).
  Default: NULL

## Value

A `pt_cld` object with normalized Z coordinates.

## Details

The function extracts a DTM mesh using
[`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md),
then for each point in the cloud, it determines which triangle in the
DTM mesh the point's XY coordinates fall within, and interpolates the Z
value at that location using barycentric coordinates. If a point's XY
location doesn't fall within any triangle, the Z value of the nearest
vertex is used as a fallback. To reduce edge effects from points falling
outside the DTM mesh bounds, it is recommended to clip the cloud to a
smaller region before normalization using functions like
[`clip_rect()`](https://ataeub.github.io/coi/reference/clip_rect.md).
This minimizes reliance on the fallback method and improves
interpolation accuracy.

## Examples

``` r
if (FALSE) { # \dontrun{
cloud <- gen_sphere(50, 1)
cloud_dtm <- extract_dtm(cloud, 2)
# We cut a small border of the cloud after the dtm extraction to prevent
# edge effects during the normalization.
cloud_cut <- clip_rect(cloud, 46)
cloud_norm <- z_normalize(cloud_cut, dtm = cloud_dtm)
# The original cloud
summary(cloud_cut[, "z"])
# The z-normalized cloud
summary(cloud_norm[, "z"])
# We can see that the normalized cloud has been shifted along z so that the
# lowest values are around 0. There will always be some points below 0 due to
# inaccuracies between the dtm and the cloud.
} # }
```
