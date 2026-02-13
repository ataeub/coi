#' Compute the crown overlap index (COI) for two raw single tree point clouds.
#'
#' Calculate the COI as described in Täuber et al. (in prep.) All-in-one
#' function handling voxelization, interaction extraction, and calculation of
#' COI.
#'
#' Takes two raw point clouds representing interacting trees
#' and voxelizes them to a given common point density. Then the interaction
#' (overlap) of the clouds is extracted according to the maximum distance
#' parameter. Finally from this interaction cloud the COI is computed.
#' This is a convenience function doing all preprocessing for COI calculation in
#' one function. You may want to inspect the interaction clouds before COI
#' computation or save them as seperate files. For this the low-level function
#' `compute_coi()` is available.
#'
#' @param cloud_i First single tree point cloud as a matrix-like object.
#' @param cloud_j Second single tree point cloud as a matrix-like object.
#' @param d_max Numeric of the maximum distance of interaction. Decides how far
#' away points of one tree can be from the other before they are excluded from
#' the interaction cloud.
#' @param vox_res Numeric of the resolution for voxelization during
#' pre-processing. If left undefined (default), the raw clouds will be analzed,
#' which should only be done if the clouds have been voxelized before 
#' independently.
#' @param warnings Logical controlling whether to display a warning when vox_res
#' is left undefined. Defaults to TRUE.
#' @return A numeric representing the COI.
#' @export
#' @examples
#' sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
#' sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
#' coi(sphere1, sphere2, 0.3, 0.05)
coi <- function(cloud_i, cloud_j, d_max, vox_res = NULL, warnings = TRUE) {
  cloud_i <- cloud_to_mat(cloud_i)
  cloud_j <- cloud_to_mat(cloud_j)

  if (!is.null(vox_res) && is.numeric(vox_res)) {
    cloud_i <- voxelize(cloud_i, vox_res)
    cloud_j <- voxelize(cloud_j, vox_res)
  } else if (is.null(vox_res) && warnings) {
    warning(
      "vox_res left undefined. Will process the raw clouds without",
      " voxelization. Only continue if you voxelized the clouds before",
      " yourself, as COI is only clearly defined for voxelized clouds. To",
      " supress this warning set warnings = FALSE."
    )
  }
  cloud_i_size <- nrow(cloud_i)
  cloud_j_size <- nrow(cloud_j)
  total_size <- sum(cloud_i_size, cloud_j_size)

  interaction <- extract_interaction(
    cloud_i = cloud_i,
    cloud_j = cloud_j,
    d_max = d_max
  )

  coi_value <- compute_coi(interaction, total_size, d_max)
  coi_value
}
