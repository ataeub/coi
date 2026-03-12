#' @title Statistical outlier removal
#'
#' @description
#' Removes statistical outlier points from a point cloud based on
#' mean k-nearest-neighbour distances.
#'
#' @details
#' For each point, the mean distance to its `n` nearest neighbours is computed.
#' Points whose mean distance exceeds the global mean plus `s` standard
#' deviations are classified as outliers and removed.
#'
#' @param cloud (matrix or data.frame) Point cloud with columns "x", "y", "z".
#' @param n (integer) Number of nearest neighbours to consider.
#' @param s (numeric) Standard deviation multiplier for the distance threshold.
#'   Must be >= 0. Lower values remove more aggressively.
#'
#' @return (matrix) Filtered point cloud with columns "x", "y", "z".
#'
#' @examples
#' sphere <- gen_sphere(1, 0.05)
#' # Add two outlier points far from the surface
#' outliers <- matrix(c(5, 5, 5, -5, -5, -5), ncol = 3, byrow = TRUE)
#' colnames(outliers) <- c("x", "y", "z")
#' noisy <- rbind(sphere, outliers)
#' cleaned <- sor(noisy, n = 10, s = 1)
#' nrow(noisy) - nrow(cleaned) # outliers removed
#'
sor <- function(cloud, n, s) {
  stopifnot(rlang::is_integerish(n))
  stopifnot(s >= 0)
  cloud <- cloud_to_mat(cloud)
  old_opt <- getOption("lidR.progress")
  options(lidR.progress = FALSE)
  on.exit(options(lidR.progress = old_opt), add = TRUE)

  d <- RANN::nn2(cloud, k = n + 1)$nn.dists[, -1]
  if (is.null(dim(d))) {
    d <- matrix(d, ncol = 1)
  }
  mean_d <- rowMeans(d)
  thr <- mean(mean_d) + s * sd(mean_d)
  cloud <- cloud[mean_d <= thr, , drop = FALSE]
  if (!all(colnames(cloud) %in% c("x", "y", "z"))) {
    colnames(cloud) <- c("x", "y", "z")
  }
  cloud
}
