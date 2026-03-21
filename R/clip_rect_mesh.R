#' Clip a mesh3d object to an axis-aligned rectangle
#'
#' @param mesh A `mesh3d` object (from the \pkg{rgl} package).
#' @param dim_x Numeric. Edge length along the x-axis.
#' @param dim_y Numeric. Edge length along the y-axis. Defaults to \code{dim_x} (square).
#' @param center Either a character string \code{"center"} (geometric center of the
#'   mesh's xy-extent) or \code{"origin"} (coordinates \code{c(0, 0)}), or a
#'   numeric vector of length 2 giving explicit \code{c(x, y)} coordinates.
#'   Partial matching is supported for character inputs.
#'
#' @return A `mesh3d` object containing only vertices within the rectangle and
#'   faces whose vertices all fall within it.
#'
#' @export
clip_rect_mesh <- function(
  mesh,
  dim_x,
  dim_y = dim_x,
  center = c("center", "origin")
) {
  vb <- mesh$vb # 4 x n matrix (homogeneous coords: x, y, z, w)
  x <- vb[1, ] / vb[4, ]
  y <- vb[2, ] / vb[4, ]

  if (is.character(center)) {
    center <- match.arg(center)
    center <- if (center == "center") {
      c(
        (max(x) + min(x)) / 2,
        (max(y) + min(y)) / 2
      )
    } else {
      c(0, 0)
    }
  }

  dx <- x - center[1]
  dy <- y - center[2]
  hw <- dim_x / 2
  hl <- dim_y / 2

  keep_v <- abs(dx) <= hw & abs(dy) <= hl # logical vector over vertices

  # Remap old vertex indices to new (compact) indices
  new_idx <- integer(ncol(vb))
  new_idx[keep_v] <- seq_len(sum(keep_v))

  # Filter faces: keep only those where every vertex index is in keep_v
  # mesh3d uses either $it (triangles, 3 x m) or $ib (quads, 4 x m)
  filter_faces <- function(it) {
    face_ok <- apply(it, 2, function(face) all(keep_v[face]))
    new_idx[it[, face_ok, drop = FALSE]]
    matrix(new_idx[it[, face_ok, drop = FALSE]],
      nrow = nrow(it)
    )
  }

  mesh$vb <- vb[, keep_v, drop = FALSE]
  if (!is.null(mesh$it)) mesh$it <- filter_faces(mesh$it)
  if (!is.null(mesh$ib)) mesh$ib <- filter_faces(mesh$ib)

  # Trim per-vertex attributes if present
  if (!is.null(mesh$normals)) mesh$normals <- mesh$normals[, keep_v, drop = FALSE]
  if (!is.null(mesh$texcoords)) mesh$texcoords <- mesh$texcoords[, keep_v, drop = FALSE]
  if (!is.null(mesh$colors)) mesh$colors <- mesh$colors[, keep_v, drop = FALSE]

  mesh
}
