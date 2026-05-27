# Convert an object to a point cloud

Generic function to convert various objects to a `pt_cld` point cloud
object.

## Usage

``` r
as_pt_cld(x, ...)

# S3 method for class 'pt_cld'
as_pt_cld(x, ...)

# S3 method for class 'matrix'
as_pt_cld(x, ...)

# S3 method for class 'data.frame'
as_pt_cld(x, ...)

# Default S3 method
as_pt_cld(x, ...)
```

## Arguments

- x:

  Object to convert.

- ...:

  Additional arguments passed to methods.

## Value

A `pt_cld` object.

## Examples

``` r
df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
cloud <- as_pt_cld(df)
```
