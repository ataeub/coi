# Statistical outlier removal

Removes statistical outlier points from a point cloud based on mean
k-nearest-neighbour distances.

## Usage

``` r
sor(cloud, n, s)
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- n:

  (integer) Number of nearest neighbours to consider.

- s:

  (numeric) Standard deviation multiplier for the distance threshold.
  Must be \>= 0. Lower values remove more aggressively.

## Value

A `pt_cld` object with outliers removed.

## Details

For each point, the mean distance to its `n` nearest neighbours is
computed. Points whose mean distance exceeds the global mean plus `s`
standard deviations are classified as outliers and removed.

## Examples

``` r
sphere <- gen_sphere(1, 0.05)
# Add two outlier points far from the surface
outliers <- matrix(c(5, 5, 5, -5, -5, -5), ncol = 3, byrow = TRUE)
colnames(outliers) <- c("x", "y", "z")
noisy <- rbind(sphere, outliers)
cleaned <- sor(noisy, n = 10, s = 1)
nrow(noisy) - nrow(cleaned) # outliers removed
#> [1] 2
```
