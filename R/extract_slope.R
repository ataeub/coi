#' Extract terrain slope from a DTM mesh.
#'
#' Computes the slope (and optionally aspect) of a digital terrain model by
#' fitting a plane to the mesh vertices via singular value decomposition (SVD).
#' The plane normal is used to derive the slope angle and, if requested, the
#' aspect (compass direction of steepest descent).
#'
#' @param dtm_mesh A `mesh3d` object as returned by [extract_dtm()].
#' @param aspect Logical; if `TRUE`, also compute the aspect (direction of
#'   steepest descent in degrees from north, clockwise). Defaults to `FALSE`.
#'
#' @return A list with element `slope` (degrees). If `aspect = TRUE`, an
#'   additional element `aspect` (degrees, 0–360 from north) is included.
#'
#' @export
#' @examples
#' # Create a tilted plane
#' x <- 1:100
#' y <- 1:100
#' plane <- expand.grid(x = x, y = y)
#' plane$z <- (-1 * plane$x - 2) / -1
#' plane <- cloud_to_mat(plane)
#' plane_dtm <- extract_dtm(plane, 2)
#' result <- extract_slope(plane_dtm, aspect = TRUE)
#' round(result$slope)  # expected: 45
#' round(result$aspect) # expected: 270 (downhill faces west / -x)
#'
extract_slope <- function(dtm_mesh, aspect = FALSE) {
  if (!inherits(dtm_mesh, "mesh3d")) {
    stop("dtm_mesh must be a mesh3d object (e.g. from extract_dtm()).")
  }

  # Extract vertices from mesh3d (4 x n homogeneous matrix -> n x 3)
  xyz <- t(dtm_mesh$vb[1:3, ])

  centroid <- colMeans(xyz)
  centered <- sweep(xyz, 2, centroid)
  svd_fit <- svd(centered)

  normal <- svd_fit$v[, 3]
  a <- normal[1]
  b <- normal[2]
  c <- normal[3]

  slope_rad <- atan(sqrt(a^2 + b^2) / abs(c))
  slope_deg <- slope_rad * 180 / pi

  out <- list(slope = slope_deg)
  if (aspect) {
    aspect_rad <- atan2(-a, -b)
    aspect_deg <- aspect_rad * 180 / pi
    if (aspect_deg < 0) aspect_deg <- aspect_deg + 360
    out$aspect <- aspect_deg
  }
  out
}
