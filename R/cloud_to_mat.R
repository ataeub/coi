#' Homogenize a given point cloud from any tabular format to a 3-column matrix.
#'
#' Turns any tabular data (data.frame, matrix, tibble) into a 3-column matrix.
#' This format is used throughout this package. Additional columns other than
#' x, y, z will be removed.

#' Simple tabular data such as xyz point clouds are computed multiples faster
#' within algorithms in R when compared against data.frames and friends.

#' @param input Any tabular data representing a point cloud.
#' @param which A string to decide which point columns the function returns.
#' Consists of the 1 to 3 characters "x", "y", or "z". Defaults to "xyz"
#' returning all columns.
#' @returns A matrix with 1 to 3 columns named "x", "y", "z" representing the
#' point cloud
#' @export
#' @examples
#' sphere <- gen_sphere(1, 0.05)
#' sphere <- as.data.frame(sphere)
#' sphere$extra_data <- 1
#' sphere_mat <- cloud_to_mat(sphere, "xy")
cloud_to_mat <- function(input, which = "xyz") {
  xyz_c <- c("x", "y", "z")
  which <- unlist(strsplit(which, ""))
  if (!all(which %in% xyz_c)) {
    stop("which must be a string containing a combination of x, y, and z")
  }
  if (!is.matrix(input)) {
    input <- as.matrix(input)
  }
  mat <- input[, 1:3]
  storage.mode(mat) <- "numeric"
  if (any(is.na(mat))) {
    stop("xyz contains NAs!")
  }
  colnames(mat) <- xyz_c
  mat <- mat[, colnames(mat) %in% which, drop = FALSE]
  mat
}