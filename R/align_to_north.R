#' @title Align point cloud to y axis
#'
#' @description Rotates a point cloud in the XY plane so the vector from `p1`
#' to `p2` aligns with the y axis, optionally offset by a heading given as a
#' cardinal direction or custom degrees.
#'
#' @details The alignment angle is computed as the angle between the p1->p2
#' vector and the y axis. If `heading` is numeric, it is added as an offset in
#' degrees. If `heading` is a cardinal direction, the corresponding quarter-turn
#' offset is applied ("north"/"n": 0°, "east"/"e": 360°, "south"/"s": 270°,
#' "west"/"w": 180°). Rotation is always around the origin (0, 0, 0).
#'
#' @param cloud matrix-like. Point cloud with columns "x", "y", "z". Use
#' `cloud_to_mat()` to get this format.
#' @param p2 numeric. Length-2 vector giving the target point defining the
#' heading direction.
#' @param p1 numeric. Length-2 vector giving the reference point
#' (default `c(0, 0)`).
#' @param heading character or numeric. Cardinal direction ("north"/"n",
#' "east"/"e", "south"/"s", "west"/"w") or a numeric degree offset to add to
#' the computed alignment angle (default `"north"`).
#'
#' @return matrix with columns "x", "y", "z" containing the rotated point
#' cloud.
#'
#' @export
#' @examples
#' cloud <- gen_sphere(1, 0.1)
#' p1 <- c(0, 0)
#' p2 <- c(1, 1)
#' aligned <- align_to_north(cloud, p2, p1, heading = "north")
#' aligned_custom <- align_to_north(cloud, p2, p1, heading = 45)
align_to_north <- function(cloud, p2, p1 = c(0, 0), heading = "north") {
  heading <- tolower(heading)
  heading_vector <- c(p2[1] - p1[1], p2[2] - p1[2])
  y_vector <- c(0 - p1[1], 1 - p1[2])
  heading_vector_u <- heading_vector / sqrt(sum(heading_vector^2))
  y_vector_u <- y_vector / sqrt(sum(y_vector^2))
  align_angle <- acos(
    min(1, max(-1, sum(heading_vector_u * y_vector_u)))
  )

  if (suppressWarnings(!is.na(as.numeric(heading)))) {
    heading_deg <- as.numeric(heading)
    align_angle <- align_angle + heading_deg * pi / 180
  } else {
    if (heading %in% c("east", "e")) {
      align_angle <- align_angle + 2 * pi
    } else if (heading %in% c("south", "s")) {
      align_angle <- align_angle + (3 * pi) / 2
    } else if (heading %in% c("west", "w")) {
      align_angle <- align_angle + pi
    }
  }

  rot_matrix <- matrix(c(
    cos(align_angle), -sin(align_angle), 0,
    sin(align_angle), cos(align_angle), 0,
    0, 0, 1
  ), nrow = 3, byrow = TRUE)

  pc_xyz <- as.matrix(cloud[, c("x", "y", "z")])
  pc_aligned <- t(rot_matrix %*% t(pc_xyz))
  cloud[, c("x", "y", "z")] <- pc_aligned

  cloud
}