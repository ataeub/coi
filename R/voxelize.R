#' Voxelize matrix-like point cloud objects.
#'
#' This is a simple round-to-multiple function which can be used to voxelize
#' point clouds.
#' 
#' @param cloud The point cloud to voxelize as a matrix-like object.
#' @param res Numeric of the voxel resolution to apply on the point cloud.
#' @export
#' @return The voxelized point cloud as a matrix with columns "x", "y", "z".
#' @examples
#' sphere <- gen_sphere(1, 0.01)
#' voxelize(sphere, 0.05)
voxelize <- function(cloud, res) {
  out <- unique(.round_n(cloud, res))
  out
}
