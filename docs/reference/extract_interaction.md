# Extract interaction distances between two point clouds.

Calculates the nearest neighbor distances between two point clouds in
both directions, returning either a numeric vector of the distances used
to compute the coi with
[`coi()`](https://ataeub.github.io/coi/reference/coi.md) or the
interaction point cloud with distances as a fourth column.

## Usage

``` r
extract_interaction(cloud_i, cloud_j, d_max, returns = c("distances", "cloud"))
```

## Arguments

- cloud_i:

  First point cloud as a matrix-like object.

- cloud_j:

  Second point cloud as a matrix-like object.

- d_max:

  Numeric of the maximum distance to consider for nearest neighbor
  search.

- returns:

  Character, either "distances" (default) to return a vector of
  distances (to use in `calculate_coi()`), or "cloud" to return the
  combined cloud with distances (useful when extracted interaction point
  cloud needs to be inspected visually).

## Value

Either a numeric vector of distances or a point cloud as a matrix with
columns "x", "y", "z", "distance".

## Examples

``` r
sphere1 <- gen_sphere(1, 0.05, c(0, 0, 0))
sphere2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
spheres_dists <- extract_interaction(sphere1, sphere2, d_max = 0.5)
```
