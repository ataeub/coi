#' Compute the box dimension structural complexity index for a given point
#' cloud.
#'
#' Calculate the box dimension as described in Seidel et al. (2018)
#'
#' @param cloud Point cloud as a matrix-like object.
#' @param threshold The lower resolution threshold until which the box dimension
#' algorithm iterates
#' @param vox_res Numeric of the resolution for voxelization. If left undefined
#' (default), the raw cloud will be analzed, which should only be done if the
#' cloud has been voxelized before independently.
#' @param warnings Logical controlling whether to display a warning when vox_res
#' is left undefined. Defaults to TRUE.
#' @return A numeric representing the box dimension.
#' @export
#' @examples
#' sphere <- gen_sphere(1, 0.01, c(0, 0, 0))
#' boxdim(sphere, 0.1, 0.05)
boxdim <- function(cloud, threshold, vox_res = NULL, warnings = TRUE) {
  cloud <- cloud_to_vector(cloud)

  if (!is.null(vox_res) && is.numeric(vox_res)) {
    cloud <- voxelize(cloud, vox_res)
  } else if (is.null(vox_res) && warnings) {
    warning(
      "vox_res left undefined. Will process the raw clouds without",
      " voxelization. Only continue if you voxelized the clouds before",
      " yourself, as the box dimension may be skewed for unhomogenized point",
      " clouds supress this warning set warnings = FALSE."
    )
  }

  mins <- apply(cloud, 2, min)
  maxs <- apply(cloud, 2, max)
  max_box <- max(maxs - mins)

  r_list <- numeric()
  n_list <- integer()

  r <- max_box

  while (r > threshold) {
    r <- r / 2
    vox_idx <- round(cloud / r)
    n <- nrow(unique(vox_idx))

    r_list <- c(r_list, r)
    n_list <- c(n_list, n)
  }

  x <- cbind(1, log(1 / r_list))
  y <- log(n_list)

  coef <- qr.solve(x, y)

  slope <- coef[2]

  boxdim <- slope
  boxdim
}
