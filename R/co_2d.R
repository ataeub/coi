#' Compute a projected 2D crown overlap index for two point clouds.
#'
#' Calculates the proportion of shared crown footprint in the x-y plane for two
#' single-tree point clouds.
#'
#' Takes two raw point clouds representing interacting trees and optionally
#' voxelizes them to a common resolution. The clouds are then projected to the
#' x-y plane by dropping z, unique footprint coordinates are extracted for each
#' tree, and the shared footprint is identified from coordinates present in
#' both clouds. The returned value is the number of shared footprint cells
#' divided by the total number of unique footprint cells across both clouds.
#'
#' @param cloud_i First single tree point cloud as a `pt_cld` object
#'   (see [as_pt_cld()]).
#' @param cloud_j Second single tree point cloud as a `pt_cld` object
#'   (see [as_pt_cld()]).
#' @param vox_res Numeric of the resolution for voxelization during
#'   pre-processing. If left undefined (default), the raw clouds will be
#'   analyzed, which should only be done if the clouds have been voxelized
#'   before independently.
#' @param warnings Logical controlling whether to display a warning when
#'   `vox_res` is left undefined. Defaults to `TRUE`.
#' @details
#' `co_2d()` measures overlap from shared projected x-y coordinates, not
#' from full 3-D point coincidence. This means crowns can overlap in 2-D even
#' when they occur at different heights. Because the overlap is derived from
#' shared footprint coordinates, the function is intended for voxelized point
#' clouds with a common resolution. The returned index ranges from 0 for no
#' projected overlap to 1 for identical projected footprints.
#' @return A numeric representing the projected 2D crown overlap index.
#' @export
#' @seealso [coi()] and [cci()] for related tree-tree interaction metrics.
#' @examples
#' sphere1 <- gen_sphere(1, 0.05, c(0, 0, 0))
#' sphere2 <- gen_sphere(1, 0.05, c(0, 0, 1))
#' co_2d(sphere1, sphere2, vox_res = 0.05, warnings = FALSE)
#'
#' sphere3 <- gen_sphere(1, 0.05, c(3, 0, 0))
#' co_2d(sphere1, sphere3, vox_res = 0.05, warnings = FALSE)
#'
#' sphere4 <- gen_sphere(1, 0.05, c(1, 0, 0))
#' co_2d(sphere1, sphere4, vox_res = 0.05, warnings = FALSE)
co_2d <- function(
  cloud_i,
  cloud_j,
  vox_res = NULL,
  warnings = TRUE
) {
  .validate_pt_cld(cloud_i, "cloud_i")
  .validate_pt_cld(cloud_j, "cloud_j")

  if (!is.null(vox_res) && is.numeric(vox_res)) {
    cloud_i <- voxelize(cloud_i, vox_res)
    cloud_j <- voxelize(cloud_j, vox_res)
  } else if (is.null(vox_res) && warnings) {
    warning(
      "vox_res left undefined. Will process the raw clouds without",
      " voxelization. Only continue if you voxelized the clouds before",
      " yourself, as co_2d() only properly functions",
      " for voxelized clouds. To supress this warning set warnings = FALSE."
    )
  }

  footprint_i <- unique(cloud_i[, c("x", "y"), drop = FALSE])
  footprint_j <- unique(cloud_j[, c("x", "y"), drop = FALSE])

  if (nrow(footprint_i) == 0 && nrow(footprint_j) == 0) {
    return(0)
  }

  footprint_ij <- rbind(footprint_i, footprint_j)
  footprint_dedup <- unique(footprint_ij)
  footprint_dedup_n <- nrow(footprint_dedup)

  overlap <- footprint_ij[duplicated(footprint_ij), , drop = FALSE]
  overlap_n <- nrow(overlap)

  overlap_2d_index <- overlap_n / footprint_dedup_n
  overlap_2d_index
}
