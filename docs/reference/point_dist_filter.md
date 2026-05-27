# Filter points by nearest-neighbour distance

Removes points whose nearest neighbouring point lies farther away than a
given maximum distance.

## Usage

``` r
point_dist_filter(cloud, max_dist)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- max_dist:

  (numeric) Maximum allowed distance to the nearest neighbouring point.
  Must be \>= 0.

## Value

A `pt_cld` object containing only points with a nearest-neighbour
distance less than or equal to `max_dist`.

## Details

For each point in `cloud`, the distance to its nearest other point is
computed using a kd-tree via
[`RANN::nn2()`](https://jefferislab.github.io/RANN/reference/nn2.html).
Points are retained only when that nearest-neighbour distance is less
than or equal to `max_dist`. This can be used to remove isolated points
from a point cloud.

## Examples

``` r
cloud <- rbind(
  gen_sphere(1, 0.5),
  matrix(c(5, 5, 5), ncol = 3, dimnames = list(NULL, c("x", "y", "z")))
)
filtered <- point_dist_filter(cloud, max_dist = 1)
nrow(filtered) == nrow(cloud) - 1
#> [1] TRUE
```
