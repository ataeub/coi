#' Extract interaction distances between two point clouds.
#'
#' Calculates the nearest neighbor distances between two point clouds in both
#' directions, returning either a numeric vector of the distances used to
#' compute the coi with `coi()` or the interaction point cloud with distances as
#' a fourth column.
#'
#' @param cloud_i First point cloud as a `pt_cld` object (see [as_pt_cld()]).
#' @param cloud_j Second point cloud as a `pt_cld` object (see [as_pt_cld()]).
#' @param d_max Numeric of the maximum distance to consider for nearest neighbor
#' search. Set to 0 if only exact point or voxel matches should be returned.
#' @param returns Character, either "distances" (default) to return a vector of
#' distances (to use in `calculate_coi()`), or "cloud" to return the combined
#' cloud with distances (useful when extracted interaction point cloud needs to
#' be inspected visually).
#' @return Either a numeric vector of distances or a point cloud as a matrix
#' with columns "x", "y", "z", "distance".
#' @export
#' @examples
#' sphere1 <- gen_sphere(1, 0.05, c(0, 0, 0))
#' sphere2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
#' spheres_dists <- extract_interaction(sphere1, sphere2, d_max = 0.5)
extract_interaction <- function(
  cloud_i,
  cloud_j,
  d_max,
  returns = c("distances", "cloud")
) {
  .validate_pt_cld(cloud_i, "cloud_i")
  .validate_pt_cld(cloud_j, "cloud_j")
  returns <- match.arg(returns)
  nn_i <- .calculate_c2c_dist(cloud_i, cloud_j, d_max)
  nn_j <- .calculate_c2c_dist(cloud_j, cloud_i, d_max)
  overlap <- rbind(nn_i, nn_j)
  if (returns == "distances") {
    overlap <- overlap[, "distance"]
  }
  overlap
}
