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
#' @param cloud (matrix or data.frame) Point cloud with columns "x", "y", "z".
#' @param length (numeric) The length (in Z units) to remove from the cloud.
#' @param from_top (logical) If TRUE, remove from top; if FALSE, remove from bottom. Default: FALSE
#'
#' @return (matrix or data.frame) The clipped point cloud with rows removed
#'   according to the clipping direction, preserving the original data structure.
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
  z <- cloud[, "z"]
  if (from_top) {
    mask <- z <= (max(z) - length)
  } else {
    mask <- z >= (min(z) + length)
  }
  cloud[mask, , drop = FALSE]
}
