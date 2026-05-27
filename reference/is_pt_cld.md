# Check if an object is a pt_cld

Check if an object is a pt_cld

## Usage

``` r
is_pt_cld(x)
```

## Arguments

- x:

  Object to test.

## Value

Logical: `TRUE` if `x` inherits from `pt_cld`, `FALSE` otherwise.

## Examples

``` r
cloud <- gen_sphere(1, 0.5)
is_pt_cld(cloud)
#> [1] TRUE
```
