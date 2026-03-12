#' Compute the Effective Number of Layers (ENL) for a voxelized point cloud.
#'
#' Calculates ENL₀, ENL₁, ENL₂ as vertical structural complexity indices.
#' Optionally plots the vertical voxel distribution.
#'
#' @param cloud Point cloud as a matrix-like object.
#' @param voxel_res Numeric voxel resolution for voxelization.
#' @param layer_thickness Numeric thickness of each vertical layer (default 1).
#' @param plot Logical, whether to plot the vertical voxel distribution (default FALSE).
#' @param plot_title Optional character string for the plot title.
#' @return If plot=FALSE, returns a list (ENL0, ENL1, ENL2). If plot=TRUE, returns list plus ggplot object.
#' @export
#' @examples
#' sphere <- gen_sphere(1, 0.01)
#' enl_stats <- enl(sphere, voxel_res = 0.05, layer_thickness = 1, plot = TRUE)
enl <- function(cloud, voxel_res, layer_thickness = 1, plot = TRUE, plot_title = NULL) {
  stopifnot(layer_thickness > 0)
  stopifnot(voxel_res > 0)
  cloud <- cloud_to_mat(cloud)

  # Voxelize the point cloud
  coords_vox <- voxelize(cloud, voxel_res)
  total_vox <- nrow(coords_vox)

  min_z <- min(coords_vox[, 3])
  max_z <- max(coords_vox[, 3])

  generate_sequence <- function(start, stop, step) {
    s <- seq(start, stop, by = step)
    # Ensure the last boundary is >= stop so all voxels are captured
    if (tail(s, 1) < stop) {
      s <- c(s, tail(s, 1) + step)
    }
    s
  }

  enl_seq <- generate_sequence(min_z, max_z, layer_thickness)
  n_bins <- length(enl_seq) - 1

  weighted_1 <- numeric(0)
  weighted_2 <- numeric(0)
  layer_fractions <- numeric(n_bins)
  layer_occupied <- logical(n_bins)

  for (idx in seq_len(n_bins)) {
    lower <- enl_seq[idx]
    upper <- enl_seq[idx + 1]
    if (idx == 1) {
      z_filter <- coords_vox[, 3] >= lower & coords_vox[, 3] <= upper
    } else {
      z_filter <- coords_vox[, 3] > lower & coords_vox[, 3] <= upper
    }
    layer <- coords_vox[z_filter, , drop = FALSE]
    filled_vox_ratio <- nrow(layer) / total_vox
    layer_fractions[idx] <- filled_vox_ratio
    if (filled_vox_ratio > 0) {
      layer_occupied[idx] <- TRUE
      weighted_1 <- c(weighted_1, filled_vox_ratio * log(filled_vox_ratio))
      weighted_2 <- c(weighted_2, filled_vox_ratio^2)
    }
  }

  # ENL0: number of non-empty layers
  enl0 <- sum(layer_occupied)
  enl1 <- exp(-sum(weighted_1))
  enl2 <- 1 / sum(weighted_2)

  if (plot) {
    if (is.null(plot_title)) {
      plot_title <- "Vertical voxel distribution"
    }
    stopifnot(is.character(plot_title))
    y_labels <- enl_seq[-1]
    df <- data.frame(height = y_labels, fraction = layer_fractions)
    p <- ggplot2::ggplot(df, ggplot2::aes(x = fraction, y = height)) +
      ggplot2::geom_col(
        width = layer_thickness * 0.9,
        fill = "forestgreen",
        orientation = "y"
      ) +
      ggplot2::scale_y_continuous(breaks = y_labels) +
      ggplot2::labs(
        x     = "Fraction of filled voxels",
        y     = "Height (z)",
        title = plot_title
      ) +
      ggplot2::theme_minimal() +
      ggplot2::annotate(
        "text",
        x = max(df$fraction, na.rm = TRUE),
        y = max(df$height, na.rm = TRUE),
        label = sprintf("ENL0: %d\nENL1: %.2f\nENL2: %.2f", enl0, enl1, enl2),
        hjust = 1, vjust = 1, size = 4,
        fontface = "bold"
      )
    return(list(ENL0 = enl0, ENL1 = enl1, ENL2 = enl2, plot = p))
  } else {
    return(list(ENL0 = enl0, ENL1 = enl1, ENL2 = enl2))
  }
}
