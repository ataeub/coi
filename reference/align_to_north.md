# Align point cloud to y axis

Rotates a point cloud in the XY plane so the vector from `p1` to `p2`
aligns with the y axis, optionally offset by a heading given as a
cardinal direction or custom degrees.

## Usage

``` r
align_to_north(cloud, p2, p1 = c(0, 0), heading = "north")
```

## Arguments

- cloud:

  A `pt_cld` object. Use
  [`as_pt_cld()`](https://ataeub.github.io/coi/reference/as_pt_cld.md)
  to convert.

- p2:

  numeric. Length-2 vector giving the target point defining the heading
  direction.

- p1:

  numeric. Length-2 vector giving the reference point (default
  `c(0, 0)`).

- heading:

  character or numeric. Cardinal direction ("north"/"n", "east"/"e",
  "south"/"s", "west"/"w") or a numeric degree offset to add to the
  computed alignment angle (default `"north"`).

## Value

A `pt_cld` object with the rotated coordinates.

## Details

The alignment angle is computed as the angle between the p1-\>p2 vector
and the y axis. If `heading` is numeric, it is added as an offset in
degrees. If `heading` is a cardinal direction, the corresponding
quarter-turn offset is applied ("north"/"n": 0°, "east"/"e": 360°,
"south"/"s": 270°, "west"/"w": 180°). Rotation is always around the
origin (0, 0, 0).

## Examples

``` r
cloud <- gen_sphere(1, 0.1)
p1 <- c(0, 0)
p2 <- c(1, 1)
aligned <- align_to_north(cloud, p2, p1, heading = "north")
aligned_custom <- align_to_north(cloud, p2, p1, heading = 45)
```
