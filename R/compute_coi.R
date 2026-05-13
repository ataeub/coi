#' Compute the crown overlap index (COI) for a vector with interaction
#' distances.
#'
#' Calculate the COI as described in Täuber et al. (in prep.) Bare
#' calculation fcunction requiring interaction distanes pre-computed with
#' `extract_interaction()`. For an all-in-one function you can use on raw single
#' tree point clouds use `coi()`.
#'
#' Takes a vector with the distances of an interaction point cloud of two
#' voxelized single tree point clouds, the size of the sum of clouds, and the
#' maximum distance parameter used to compute said interaction vector and
#' calculates the COI from it.
#'
#' @param distances Vector with interaction distances.
#' @param size_weight Numeric of the size (Number of points/voxels) of both
#' clouds from which the interaction distances were computed.
#' @param d_max Numeric of the maximum distance of interaction used to extract
#' the interaction distances with `extract_interaction()`.
#' @return Numeric representing the COI.
#' @export
#' @examples
#' sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
#' sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
#' sphere1_v <- voxelize(sphere1, 0.05)
#' sphere2_v <- voxelize(sphere2, 0.05)
#' sphere1_v_size <- nrow(sphere1_v)
#' sphere2_v_size <- nrow(sphere2_v)
#' size_total <- sum(sphere1_v_size, sphere2_v_size)
#' d_max <- 0.3
#' i_dists <- extract_interaction(sphere1_v, sphere2_v, d_max)
#' compute_coi(i_dists, size_total, d_max)
compute_coi <- function(distances, size_weight, d_max) {
  if (length(distances) == 0) {
    warning("No overlap detected between the analyzed clouds.")
    return(0)
  }
  distances_max <- max(distances)
  distances_min <- min(distances)
  if (distances_min < 0) {
    stop(
      "Negative distances detected, which are impossible! Please compute ",
      "distances using the extract_interaction() function"
    )
  }
  if (distances_max == 0) {
    warning(
      "All measured distances equal 0, which suggests that the ",
      "interaction was extracted for two identical clouds! Please check data ",
      "carefully."
    )
  }

  coi_value <- sum(1 - (distances / d_max)) / size_weight
  coi_value
}