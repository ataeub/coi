#' Clip a point cloud to an axis-aligned rectangle
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param dim_x Numeric. Edge length along the x-axis.
#' @param dim_y Numeric. Edge length along the y-axis. Defaults to \code{dim_x} (square).
#' @param center Either a character string \code{"center"} (geometric center of the
#'   cloud's xy-extent) or \code{"origin"} (coordinates \code{c(0, 0)}), or a
#'   numeric vector of length 2 giving explicit \code{c(x, y)} coordinates.
#'   Partial matching is supported for character inputs.
#'
#' @return A `pt_cld` object containing only points within the specified
#'   rectangle.
#'
#' @export
#' @examples
#' cloud <- gen_sphere(20, 0.5)
#' cloud_clipped <- clip_rect(cloud, dim_x = 5, dim_y = 6, center = "center")
#' min(cloud_clipped[, "x"])
#' max(cloud_clipped[, "y"])

clip_rect <- function(
  cloud,
  dim_x,
  dim_y = dim_x,
  center = c("center", "origin")
) {
  .validate_pt_cld(cloud)
  if (is.character(center)) {
    center <- match.arg(center)
    center <- if (center == "center") {
      c(
        (max(cloud[, "x"]) + min(cloud[, "x"])) / 2,
        (max(cloud[, "y"]) + min(cloud[, "y"])) / 2
      )
    } else {
      c(0, 0)
    }
  }

  dx <- cloud[, "x"] - center[1]
  dy <- cloud[, "y"] - center[2]
  hw <- dim_x / 2
  hl <- dim_y / 2
  mask <- abs(dx) <= hw & abs(dy) <= hl
  cloud[mask, , drop = FALSE]
}
