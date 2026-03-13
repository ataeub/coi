#' Convert tabular data to a point cloud matrix
#'
#' @description
#' `cloud_to_mat()` is deprecated. Use [as_pt_cld()] or [pt_cld()] instead,
#' which return a proper `pt_cld` class object.
#'
#' @param input Any tabular data representing a point cloud.
#' @param which A string to decide which point columns the function returns.
#' Consists of the 1 to 3 characters "x", "y", or "z". Defaults to "xyz"
#' returning all columns.
#' @returns A `pt_cld` object (when `which = "xyz"`) or a matrix subset.
#' @export
#' @examples
#' sphere <- gen_sphere(1, 0.05)
#' sphere <- as.data.frame(sphere)
#' cloud <- as_pt_cld(sphere)
cloud_to_mat <- function(input, which = "xyz") {
  .Deprecated("as_pt_cld")
  cloud <- as_pt_cld(input)
  which_cols <- unlist(strsplit(which, ""))
  if (!all(which_cols %in% c("x", "y", "z"))) {
    stop("which must be a string containing a combination of x, y, and z")
  }
  if (identical(sort(which_cols), c("x", "y", "z"))) {
    return(cloud)
  }
  unclass(cloud)[, which_cols, drop = FALSE]
}