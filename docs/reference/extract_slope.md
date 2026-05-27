# Extract terrain slope from a DTM mesh.

Computes the slope (and optionally aspect) of a digital terrain model by
fitting a plane to the mesh vertices via singular value decomposition
(SVD). The plane normal is used to derive the slope angle and, if
requested, the aspect (compass direction of steepest descent).

## Usage

``` r
extract_slope(dtm_mesh, aspect = FALSE)
```

## Arguments

- dtm_mesh:

  A `mesh3d` object as returned by
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md).

- aspect:

  Logical; if `TRUE`, also compute the aspect (direction of steepest
  descent in degrees from north, clockwise). Defaults to `FALSE`.

## Value

A list with element `slope` (degrees). If `aspect = TRUE`, an additional
element `aspect` (degrees, 0–360 from north) is included.

## Examples

``` r
# Create a tilted plane
x <- 1:20
y <- 1:20
plane <- expand.grid(x = x, y = y)
plane$z <- (-1 * plane$x - 2) / -1
plane <- as_pt_cld(plane)
plane_dtm <- extract_dtm(plane, 2)
result <- extract_slope(plane_dtm, aspect = TRUE)
round(result$slope)  # expected: 45
#> [1] 44
round(result$aspect) # expected: 270 (downhill faces west / -x)
#> [1] 90
```
