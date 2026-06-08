# Changelog

## coi (development version)

### Changes in version 2.1.0

- Added [`co_2d()`](https://ataeub.github.io/coi/reference/co_2d.md) to
  extract relative 2D crown overlap (very similar to
  [`coi()`](https://ataeub.github.io/coi/reference/coi.md) just in 2D
  and without point distance weighting)

### Changes in version 2.0.0

#### New functionality

- Added
  [`save_to_laz()`](https://ataeub.github.io/coi/reference/save_to_laz.md)
  for writing point clouds to LAZ files.
- Added
  [`z_normalize()`](https://ataeub.github.io/coi/reference/z_normalize.md)
  and
  [`extract_dtm()`](https://ataeub.github.io/coi/reference/extract_dtm.md)
  for terrain extraction and height normalization workflows.
- Added
  [`clip_rect()`](https://ataeub.github.io/coi/reference/clip_rect.md),
  [`clip_rect_mesh()`](https://ataeub.github.io/coi/reference/clip_rect_mesh.md),
  and [`clip_z()`](https://ataeub.github.io/coi/reference/clip_z.md) for
  spatial subsetting of point clouds.
- Added
  [`align_to_north()`](https://ataeub.github.io/coi/reference/align_to_north.md),
  [`extract_slope()`](https://ataeub.github.io/coi/reference/extract_slope.md),
  [`sor()`](https://ataeub.github.io/coi/reference/sor.md), and
  [`point_dist_filter()`](https://ataeub.github.io/coi/reference/point_dist_filter.md)
  for point-cloud preprocessing and filtering.
- Added [`enl()`](https://ataeub.github.io/coi/reference/enl.md) and
  [`canopy_stats()`](https://ataeub.github.io/coi/reference/canopy_stats.md)
  for additional canopy structure metrics.
- Added a `pt_cld` S3 class with coercion, printing, plotting, and
  subsetting methods, and updated point-cloud functions to work with it.

#### Improvements

- Added an improved COI formula and better handling of no-distance cases
  and standard warnings in
  [`compute_coi()`](https://ataeub.github.io/coi/reference/compute_coi.md).
- Expanded
  [`boxdim()`](https://ataeub.github.io/coi/reference/boxdim.md)
  plotting with optional plotting, custom plot titles, plot statistics,
  and raster rendering via
  [`geom_tile()`](https://ggplot2.tidyverse.org/reference/geom_tile.html).
- Added voxel selection support to
  [`enl()`](https://ataeub.github.io/coi/reference/enl.md).
- Promoted `ggplot2` and `ggtext` to package imports to support plotting
  features.

#### Fixes

- Fixed a bug in the internal stratification logic affecting CCI
  calculation.
- Fixed an error in the shoelace-based area calculation.
- Corrected the
  [`save_to_laz()`](https://ataeub.github.io/coi/reference/save_to_laz.md)
  argument name in the documentation.
