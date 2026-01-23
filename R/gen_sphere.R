#' Generate an artifical voxelized point cloud of a sphere.
#'
#' @param r Numeric of the radius of the sphere.
#' @param res Numeric of the voxel resolution of the cloud.
#' @param center Three element vector (x, y, z) of the center point of the
#' cloud.
#' @return A point cloud as a matrix with columns "x", "y", "z".
#' @export
#' @examples
#' # Generate 1 meter sphere with 5 cm voxel resolution at center (1,2,3)
#' gen_sphere(1, 0.05, c(1, 2, 3))

gen_sphere <- function(r, res, center = c(0, 0, 0)) {
  x <- seq(-r, r, by = res)
  y <- seq(-r, r, by = res)
  z <- seq(-r, r, by = res)

  grid <- as.matrix(expand.grid(x = x, y = y, z = z))

  sphere_idx <- rowSums(grid^2) <= r^2
  sphere <- grid[sphere_idx, , drop = FALSE]

  sphere <- sweep(sphere, 2, center, "+")

  colnames(sphere) <- c("x", "y", "z")

  sphere
}
