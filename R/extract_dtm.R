#' @title Extract digital terrain model from point cloud
#'
#' @description
#' Extracts a digital terrain model (DTM) mesh from a point cloud by computing
#' the minimum Z value within each grid cell and triangulating the result.
#'
#' @details
#' The function divides the point cloud into a regular grid based on the resolution
#' parameter, extracts the minimum Z value (ground elevation) for each cell, and
#' creates a Delaunay triangulation mesh from these ground points. Optional smoothing
#' can be applied to the resulting mesh using various smoothing algorithms.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param res (numeric) Grid cell resolution for DTM extraction. Determines the spacing
#'   of ground points in the resulting mesh.
#' @param sm_type (character) Smoothing algorithm type; passed to `Rvcg::vcgSmooth()`.
#'   Options include "taubin", "laplace", "fuhrmann", etc. Default: NULL
#' @param sm_i (integer) Number of smoothing iterations. Default: NULL
#' @param sm_lambda (numeric) Smoothing lambda parameter. Default: NULL
#' @param sm_mu (numeric) Smoothing mu parameter. Default: NULL
#' @param sm_delta (numeric) Smoothing delta parameter. Default: NULL
#'
#' @return (mesh3d) A 3D mesh object representing the DTM surface, suitable for use
#'   with `z_normalize()` or visualization with `rgl::shade3d()`.
#'
#' @export
#' @examples
#' \dontrun{
#' cloud <- gen_sphere(50, 1)
#' dtm <- extract_dtm(cloud, res = 2)
#' # Visualize the DTM
#' rgl::shade3d(dtm, col = "gray")
#' }
#'
extract_dtm <- function(
  cloud,
  res,
  sm_type = NULL,
  sm_i = NULL,
  sm_lambda = NULL,
  sm_mu = NULL,
  sm_delta = NULL
) {
  .validate_pt_cld(cloud)

  ix <- floor(cloud[, "x"] / res)
  iy <- floor(cloud[, "y"] / res)

  cell <- paste(ix, iy, sep = "_")

  zmin_per_cell <- tapply(cloud[, "z"], cell, min)

  cells <- do.call(rbind, strsplit(names(zmin_per_cell), "_"))
  x <- (as.numeric(cells[, 1]) + 0.5) * res
  y <- (as.numeric(cells[, 2]) + 0.5) * res
  z <- as.numeric(zmin_per_cell)

  cloud <- cbind(x = x, y = y, z = z)

  cloud_2d <- cloud[, 1:2]
  if (!requireNamespace("geometry", quietly = TRUE)) {
    stop("Package 'geometry' is required for extract_dtm(). Install it with install.packages('geometry').")
  }
  if (!requireNamespace("rgl", quietly = TRUE)) {
    stop("Package 'rgl' is required for extract_dtm(). Install it with install.packages('rgl').")
  }
  tri_2d <- geometry::delaunayn(cloud_2d)
  mesh <- rgl::tmesh3d(
    vertices = t(cloud),
    indices = t(tri_2d),
    homogeneous = FALSE
  )
  if (!is.null(sm_type)) {
    sm_args <- list(mesh = mesh, type = sm_type)
    if (!is.null(sm_i))      sm_args$iteration <- sm_i
    if (!is.null(sm_lambda)) sm_args$lambda    <- sm_lambda
    if (!is.null(sm_mu))     sm_args$mu        <- sm_mu
    if (!is.null(sm_delta))  sm_args$delta     <- sm_delta
    mesh <- do.call(Rvcg::vcgSmooth, sm_args)
  }
  mesh
}
