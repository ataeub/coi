#' Save cloud to a .laz file
#'
#' Converts a cloud in matrix format to a .laz file using the rlas package.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param file_path Character string specifying the output file path.
#' @return None. Writes a LAZ file to disk.
#' @export
#' @examples
#' \dontrun{
#'   cloud <- gen_sphere(1, 0.3)
#'   save_to_laz(cloud, "cloud_out.laz")
#' }
save_to_laz <- function(cloud, file_path) {
  .validate_pt_cld(cloud)
  if (!requireNamespace("rlas", quietly = TRUE)) {
    stop("Package 'rlas' is required for save_to_laz(). Install it with install.packages('rlas').")
  }
  cloud <- as.data.frame(cloud)
  colnames(cloud) <- c("X", "Y", "Z")
  cloud$ReturnNumber <- 0L
  cloud$NumberOfReturns <- 0L
  header <- rlas::header_create(cloud)
  rlas::write.las(file_path, header, cloud)
}
