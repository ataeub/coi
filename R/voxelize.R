#' Voxelize matrix-like point cloud objects.
#'
#' This is a simple round-to-multiple function which can be used to voxelize
#' point clouds.
#'
#' @param cloud A `pt_cld` object (see [as_pt_cld()]).
#' @param res Numeric of the voxel resolution to apply on the point cloud.
#' @export
#' @return A `pt_cld` object with the voxelized point cloud.
#' @examples
#' sphere <- gen_sphere(1, 0.01)
#' sphere_v <- voxelize(sphere, 0.05)
voxelize <- function(cloud, res) {
  .validate_pt_cld(cloud)
  out <- unique(.round_n(cloud, res))
  pt_cld(out)
}
