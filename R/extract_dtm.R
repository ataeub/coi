#' @export
extract_dtm <- function(
  cloud,
  res,
  sm_type = NULL,
  sm_i = NULL,
  sm_lambda = NULL,
  sm_mu = NULL,
  sm_delta = NULL
) {
  cloud <- cloud_to_mat(cloud)

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
  tri_2d <- geometry::delaunayn(cloud_2d)
  mesh <- rgl::tmesh3d(
    vertices = t(cloud),
    indices = t(tri_2d),
    homogeneous = FALSE
  )
  if (!is.null(sm_type)) {
    mesh <- Rvcg::vcgSmooth(
      mesh,
      type = sm_type,
      iteration = sm_i,
      lambda = sm_lambda,
      mu = sm_mu,
      delta = sm_delta
    )
  }
  mesh
}
