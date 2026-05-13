 #' @title Filter points by nearest-neighbour distance
 #'
 #' @description
 #' Removes points whose nearest neighbouring point lies farther away than a
 #' given maximum distance.
 #'
 #' @details
 #' For each point in `cloud`, the distance to its nearest other point is
 #' computed using a kd-tree via `RANN::nn2()`. Points are retained only when
 #' that nearest-neighbour distance is less than or equal to `max_dist`.
 #' This can be used to remove isolated points from a point cloud.
 #'
 #' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
 #' @param max_dist (numeric) Maximum allowed distance to the nearest
 #' neighbouring point. Must be >= 0.
 #'
 #' @return A `pt_cld` object containing only points with a nearest-neighbour
 #'   distance less than or equal to `max_dist`.
 #'
 #' @export
 #' @examples
 #' cloud <- rbind(
 #'   gen_sphere(1, 0.5),
 #'   matrix(c(5, 5, 5), ncol = 3, dimnames = list(NULL, c("x", "y", "z")))
 #' )
 #' filtered <- point_dist_filter(cloud, max_dist = 1)
 #' nrow(filtered) == nrow(cloud) - 1
 #'
point_dist_filter <- function(cloud, max_dist) {
  stopifnot(is.numeric(max_dist))
  stopifnot(max_dist >= 0)
  .validate_pt_cld(cloud)
  nn <- RANN::nn2(cloud, cloud, k = 2)
  keep <- nn$nn.dists[, 2] <= max_dist
  cloud[keep, ]
}
