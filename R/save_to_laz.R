#' Save cloud to a .laz file
#'
#' Converts a cloud in matrix format to a .laz file using the rlas package.
#'
#' @param mat A point cloud as a matrix-like object.
#' @param file_path Character string specifying the output file path.
#' @return None. Writes a LAZ file to disk.
#' @export
#' @examples
#' \dontrun{
#'   cloud <- gen_sphere(1, 0.3)
#'   save_to_laz(cloud, "cloud_out.laz")
#' }
save_to_laz <- function(mat, file_path) {
  mat <- as.data.frame(mat)
  colnames(mat) <- c("X", "Y", "Z")
  mat$ReturnNumber <- 0L
  mat$NumberOfReturns <- 0L
  header <- rlas::header_create(mat)
  rlas::write.las(file_path, header, mat)
}
