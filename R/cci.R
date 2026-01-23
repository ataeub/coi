#' Compute the crown complementarity index (CCI) for two raw single tree point
#' clouds.
#'
#' Calculate the CCI as described in Williams et al. 2017 in prep. All-in-one
#' function handling voxelization, and calculation of CCI.
#'
#' Takes two raw point clouds representing interacting trees
#' and voxelizes them to a given common point density. Then CCI is computed.
#'
#' @param cloud_i First single tree point cloud as a matrix-like object.
#' @param cloud_j Second single tree point cloud as a matrix-like object.
#' @param strata_size Numeric of the size of the vertical strata used within the
#' CCI algorithm. See Details and Williams et al. 2017.
#' @param hull_type String controlling the type of hull algorithm used to
#' extract the area of each stratum. "Concave" (default) and "convex" are
#' possible. See Details.
#' @param vox_res Numeric of the resolution for voxelization during
#' pre-processing. If left undefined (default), the raw clouds will be analzed,
#' which should only be done if the clouds have been voxelized before
#' independently.
#' @param warnings Logical controlling whether to display a warning when vox_res
#' is left undefined. Defaults to TRUE.
#' @return A numeric representing the CCI.
#' @export
#' @examples
#' sphere1 <- gen_sphere(1, 0.01, c(0, 0, 0))
#' sphere2 <- gen_sphere(1, 0.01, c(0, 0.5, 0))
#' cci(sphere1, sphere2, 0.3, "concave", 0.05)
cci <- function(
  cloud_i,
  cloud_j,
  strata_size,
  hull_type = c("concave", "convex"),
  vox_res = NULL,
  warnings
) {
  hull_type <- match.arg(hull_type)

  cloud_i <- cloud_to_mat(cloud_i)
  cloud_j <- cloud_to_mat(cloud_j)

  if (!is.null(vox_res) && is.numeric(vox_res)) {
    cloud_i <- voxelize(cloud_i, vox_res)
    cloud_j <- voxelize(cloud_j, vox_res)
  } else if (is.null(vox_res) && warnings) {
    warning(
      "vox_res left undefined. Will process the raw clouds without",
      " voxelization. Only continue if you voxelized the clouds before",
      " yourself, as CCI may be skewed for unhomogenized point clouds",
      " supress this warning set warnings = FALSE."
    )
  }

  strata_i <- .stratify(cloud_i, strata_size)
  strata_j <- .stratify(cloud_j, strata_size)

  max_stratum <- max(length(strata_i), length(strata_j))

  strata_i <- .pad_layers(strata_i, max_stratum)
  strata_j <- .pad_layers(strata_j, max_stratum)

  areas_i <- sapply(strata_i, .get_stratum_area, hull_type = hull_type)
  areas_j <- sapply(strata_j, .get_stratum_area, hull_type = hull_type)

  cci_value <- sum(abs(areas_i - areas_j)) / (sum(areas_i) + sum(areas_j))
  cci_value
}
