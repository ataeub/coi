# coi (development version)

## Changes in version 2.3.0

- Fix bug that parts cut away by `lower_cutoff` are not recognized as empty 
- Fixed minor bugs in logic of `canopy_stats()`

## Changes in version 2.2.0

- Added circular footprint support to `canopy_stats()` openness calculations via the `footprint` and `radius` arguments.
- Clarified that circular footprints in `canopy_stats()` require an explicit `radius`, and updated examples and tests accordingly.

## Changes in version 2.1.0

- Added `co_2d()` to extract relative 2D crown overlap (very similar to `coi()` just in 2D and without point distance weighting)

## Changes in version 2.0.0

### New functionality

- Added `save_to_laz()` for writing point clouds to LAZ files.
- Added `z_normalize()` and `extract_dtm()` for terrain extraction and height normalization workflows.
- Added `clip_rect()`, `clip_rect_mesh()`, and `clip_z()` for spatial subsetting of point clouds.
- Added `align_to_north()`, `extract_slope()`, `sor()`, and `point_dist_filter()` for point-cloud preprocessing and filtering.
- Added `enl()` and `canopy_stats()` for additional canopy structure metrics.
- Added a `pt_cld` S3 class with coercion, printing, plotting, and subsetting methods, and updated point-cloud functions to work with it.

### Improvements

- Added an improved COI formula and better handling of no-distance cases and standard warnings in `compute_coi()`.
- Expanded `boxdim()` plotting with optional plotting, custom plot titles, plot statistics, and raster rendering via `geom_tile()`.
- Added voxel selection support to `enl()`.
- Promoted `ggplot2` and `ggtext` to package imports to support plotting features.

### Fixes

- Fixed a bug in the internal stratification logic affecting CCI calculation.
- Fixed an error in the shoelace-based area calculation.
- Corrected the `save_to_laz()` argument name in the documentation.
