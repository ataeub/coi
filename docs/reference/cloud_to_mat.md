# Homogenize a given point cloud from any tabular format to a 3-column matrix.

Turns any tabular data (data.frame, matrix, tibble) into a 3-column
matrix. This format is used throughout this package. Additional columns
other than x, y, z will be removed. Simple tabular data such as xyz
point clouds are computed multiples faster within algorithms in R when
compared against data.frames and friends.

## Usage

``` r
cloud_to_mat(input, which = "xyz")
```

## Arguments

- input:

  Any tabular data representing a point cloud.

- which:

  A string to decide which point columns the function returns. Consists
  of the 1 to 3 characters "x", "y", or "z". Defaults to "xyz" returning
  all columns.

## Value

A matrix with 1 to 3 columns named "x", "y", "z" representing the point
cloud

## Examples

``` r
sphere <- gen_sphere(1, 0.05)
sphere <- as.data.frame(sphere)
sphere$extra_data <- 1
sphere_mat <- cloud_to_mat(sphere, "xy")
#> Error in cloud_to_mat(sphere, "xy"): could not find function "cloud_to_mat"
```
