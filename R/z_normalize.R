#' @title Normalize point cloud to digital terrain model
#'
#' @description
#' Normalizes a point cloud by computing a digital terrain model (DTM) mesh and
#' calculating the normalized Z coordinates for each point based on its elevation
#' relative to the DTM surface.
#'
#' @details
#' The function extracts a DTM mesh using `extract_dtm()`, then for each point in
#' the cloud, it determines which triangle in the DTM mesh the point's XY coordinates
#' fall within, and interpolates the Z value at that location using barycentric
#' coordinates. If a point's XY location doesn't fall within any triangle, the
#' Z value of the nearest vertex is used as a fallback. To reduce edge effects from
#' points falling outside the DTM mesh bounds, it is recommended to clip the cloud
#' to a smaller region before normalization using functions like `clip_rect()`.
#' This minimizes reliance on the fallback method and improves interpolation accuracy.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param res (numeric) Resolution parameter for DTM mesh extraction. Ignored if `dtm` is provided. Default: NULL
#' @param dtm (mesh3d object) Pre-computed DTM mesh object. If provided, `res` and smoothing parameters are ignored. Default: NULL
#' @param sm_type (character) Smoothing type; passed to `extract_dtm()`. Default: NULL
#' @param sm_i (integer) Smoothing iterations; passed to `extract_dtm()`. Default: NULL
#' @param sm_lambda (numeric) Smoothing lambda parameter; passed to `extract_dtm()`. Default: NULL
#' @param sm_mu (numeric) Smoothing mu parameter; passed to `extract_dtm()`. Default: NULL
#' @param sm_delta (numeric) Smoothing delta parameter; passed to `extract_dtm()`. Default: NULL
#'
#' @return A `pt_cld` object with normalized Z coordinates.
#'
#' @export
#' @examples
#' \dontrun{
#' cloud <- gen_sphere(50, 1)
#' cloud_dtm <- extract_dtm(cloud, 2)
#' # We cut a small border of the cloud after the dtm extraction to prevent
#' # edge effects during the normalization.
#' cloud_cut <- clip_rect(cloud, 46)
#' cloud_norm <- z_normalize(cloud_cut, dtm = cloud_dtm)
#' # The original cloud
#' summary(cloud_cut[, "z"])
#' # The z-normalized cloud
#' summary(cloud_norm[, "z"])
#' # We can see that the normalized cloud has been shifted along z so that the
#' # lowest values are around 0. There will always be some points below 0 due to
#' # inaccuracies between the dtm and the cloud.
#' }
z_normalize <- function(
  cloud,
  res = NULL,
  dtm = NULL,
  sm_type = NULL,
  sm_i = NULL,
  sm_lambda = NULL,
  sm_mu = NULL,
  sm_delta = NULL
) {
  .validate_pt_cld(cloud)

  if (is.null(dtm)) {
    if (is.null(res)) {
      stop("Either `res` or `dtm` must be provided.")
    }
    dtm_mesh <- extract_dtm(
      cloud, res,
      sm_type = sm_type, sm_i = sm_i,
      sm_lambda = sm_lambda, sm_mu = sm_mu, sm_delta = sm_delta
    )
  } else {
    dtm_mesh <- dtm
  }

  verts <- t(dtm_mesh$vb[1:3, ]) # n x 3
  faces <- t(dtm_mesh$it) # m x 3

  if (nrow(verts) == 0 || nrow(faces) == 0) {
    stop("DTM mesh has no vertices or faces. Try a finer `res`.")
  }

  # Precompute triangle XY data for vectorised point-in-triangle test
  v0 <- verts[faces[, 1], , drop = FALSE]
  v1 <- verts[faces[, 2], , drop = FALSE]
  v2 <- verts[faces[, 3], , drop = FALSE]

  # Barycentric denominator (scalar per triangle, in XY only)
  denom <- (v1[, 2] - v2[, 2]) * (v0[, 1] - v2[, 1]) +
    (v2[, 1] - v1[, 1]) * (v0[, 2] - v2[, 2])

  px <- cloud[, "x"]
  py <- cloud[, "y"]
  pz <- cloud[, "z"]

  z_ground <- numeric(nrow(cloud))

  for (i in seq_len(nrow(cloud))) {
    dx <- px[i] - v2[, 1]
    dy <- py[i] - v2[, 2]

    w1 <- ((v1[, 2] - v2[, 2]) * dx + (v2[, 1] - v1[, 1]) * dy) / denom
    w2 <- ((v2[, 2] - v0[, 2]) * dx + (v0[, 1] - v2[, 1]) * dy) / denom
    w3 <- 1 - w1 - w2

    # Find triangle containing this point (all barycentric coords >= 0)
    hit <- which(w1 >= -1e-10 & w2 >= -1e-10 & w3 >= -1e-10)[1]

    if (!is.na(hit)) {
      z_ground[i] <- w1[hit] * v0[hit, 3] +
        w2[hit] * v1[hit, 3] +
        w3[hit] * v2[hit, 3]
    } else {
      # Fallback: nearest vertex in XY
      d2 <- (verts[, 1] - px[i])^2 + (verts[, 2] - py[i])^2
      z_ground[i] <- verts[which.min(d2), 3]
    }
  }

  # Return point cloud with normalized Z values
  cloud[, "z"] <- pz - z_ground
  cloud
}
# z_normalize_old <- function(
#   cloud,
#   res,
#   sm_type = NULL,
#   sm_i = NULL,
#   sm_lambda = NULL,
#   sm_mu = NULL,
#   sm_delta = NULL,
#   sample_pts = NULL
# ) {
#   cloud <- cloud_to_mat(cloud)

#   dtm_mesh <- extract_dtm(
#     cloud,
#     res,
#     sm_type = sm_type,
#     sm_i = sm_i,
#     sm_lambda = sm_lambda,
#     sm_mu = sm_mu,
#     sm_delta = sample_pts
#   )
#   dtm_vertices <- t(dtm_mesh$vb[1:3, ])
#   nn <- Rvcg::vcgClostKD(
#     cbind(cloud[, c("x", "y")], z = 0),
#     cbind(dtm_vertices[, c("x", "y")], z = 0)
#   )
#   cloud[, "z"] <- cloud[, "z"] - dtm_vertices[nn$index, "z"]
#   cloud
# }
