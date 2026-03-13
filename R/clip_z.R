#' @title Clip point cloud vertically
#'
#' @description
#' Removes points from the top or bottom of a point cloud along the Z-axis,
#' preserving the remaining vertical slice.
#'
#' @details
#' The function uses the `from_top` parameter to determine the clipping direction:
#' if `from_top = TRUE`, points are removed from the top of the cloud (above
#' max_z - length); if `from_top = FALSE`, points are removed from the bottom
#' (below min_z + length). This is useful for removing canopy or ground points
#' when focusing on a specific height range.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param length (numeric) The length (in Z units) to remove from the cloud.
#' @param from_top (logical) If TRUE, remove from top; if FALSE, remove from bottom. Default: FALSE
#'
#' @return A `pt_cld` object with the clipped point cloud.
#'
#' @export
#' @examples
#' cloud <- gen_sphere(50, 1)
#' # Remove bottom 5 units
#' clipped_bottom <- clip_z(cloud, 5, from_top = FALSE)
#' # Remove top 5 units
#' clipped_top <- clip_z(cloud, 5, from_top = TRUE)
#'
clip_z <- function(cloud, length, from_top = FALSE) {
  .validate_pt_cld(cloud)
  z <- cloud[, "z"]
  if (from_top) {
    mask <- z <= (max(z) - length)
  } else {
    mask <- z >= (min(z) + length)
  }
  cloud[mask, , drop = FALSE]
}
