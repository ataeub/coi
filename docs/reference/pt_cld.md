# Create a point cloud object

Creates a `pt_cld` object from a matrix, data.frame, or individual x, y,
z vectors. This is the standard point cloud format used throughout this
package.

## Usage

``` r
pt_cld(x, y = NULL, z = NULL)
```

## Arguments

- x:

  A matrix or data.frame with at least 3 columns (x, y, z), or a numeric
  vector of x-coordinates when `y` and `z` are also provided.

- y:

  Numeric vector of y-coordinates. Only used when `x` is a vector.

- z:

  Numeric vector of z-coordinates. Only used when `x` is a vector.

## Value

A `pt_cld` object: a 3-column numeric matrix with columns "x", "y", "z".

## Examples

``` r
# From vectors
cloud <- pt_cld(1:10, 11:20, 21:30)

# From a data.frame
df <- data.frame(x = 1:10, y = 11:20, z = 21:30)
cloud <- pt_cld(df)

# From a matrix
mat <- matrix(runif(30), ncol = 3)
cloud <- pt_cld(mat)
```
