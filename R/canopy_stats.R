#' Compute canopy height statistics from a point cloud.
#'
#' Calculate various canopy height statistics from a point cloud rasterized
#' to a grid. The cloud is snapped to a regular grid and the maximum height
#' per cell is extracted. Statistics are computed for heights above a given
#' threshold.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param res Numeric of the grid resolution for rasterization.
#' @param lower_cutoff Numeric of the minimum canopy height threshold. Heights
#' below this value are excluded from statistics calculation.
#' @param plot Logical controlling whether to plot the rasterized canopy height
#' grid. Defaults to TRUE.
#' @param plot_title Character string for the plot title. Only used when
#' `plot = TRUE`. Defaults to "Canopy Height Raster".
#'
#' @return A list with elements "max", "mean", "sd", "cv" (coefficient of
#' variation), "gini" (Gini coefficient) of canopy heights, and "grid"
#' (the rasterized height matrix). If `plot = TRUE`, an additional "plot"
#' element containing a ggplot object is included.
#'
#' @importFrom rlang .data
#' @export
#' @examples
#' \dontrun{
#' sphere <- gen_sphere(1, 0.01)
#' stats <- canopy_stats(sphere, res = 0.1, lower_cutoff = 0.5, plot = FALSE)
#' }
#'
canopy_stats <- function(
  cloud,
  res,
  lower_cutoff = NULL,
  plot = TRUE,
  plot_title = NULL
) {
  .validate_pt_cld(cloud)

  if (!is.numeric(res) || res <= 0) {
    stop("res must be a positive numeric value.")
  }
  if (!is.null(lower_cutoff)) {
    if (!is.numeric(lower_cutoff)) {
      stop("lower_cutoff must be numeric.")
    }
    if (lower_cutoff < 0) {
      stop("lower_cutoff must be >= 0.")
    }
  }
  if (!is.logical(plot)) {
    stop("plot must be logical.")
  }

  x_vox <- .round_n(cloud[, "x"], res)
  y_vox <- .round_n(cloud[, "y"], res)
  z <- cloud[, "z"]

  cells <- data.frame(x = x_vox, y = y_vox, z = z)
  raster <- stats::aggregate(z ~ x + y, data = cells, FUN = max)

  canopy_heights <- raster$z
  if (!is.null(lower_cutoff)) {
    canopy_heights <- canopy_heights[canopy_heights > lower_cutoff]
  }

  if (length(canopy_heights) == 0) {
    warning("No canopy heights found above lower_cutoff. Statistics will be NA.")
    return(list(
      max = NA_real_, mean = NA_real_, sd = NA_real_,
      cv = NA_real_, gini = NA_real_, grid = NULL
    ))
  }

  ch_sd <- if (length(canopy_heights) > 1) stats::sd(canopy_heights) else NA_real_
  ch_mean <- mean(canopy_heights)
  stats <- list(
    max  = max(canopy_heights),
    mean = ch_mean,
    sd   = ch_sd,
    cv   = if (!is.na(ch_sd)) ch_sd / ch_mean else NA_real_,
    gini = .gini(canopy_heights)
  )
  out <- stats

  xi <- sort(unique(raster$x))
  yi <- sort(unique(raster$y))
  grid <- matrix(NA,
    nrow = length(yi), ncol = length(xi),
    dimnames = list(yi, xi)
  )
  for (i in seq_len(nrow(raster))) {
    grid[as.character(raster$y[i]), as.character(raster$x[i])] <- raster$z[i]
  }
  out$grid <- grid

  if (plot) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Package 'ggplot2' is required for plotting. Install it with install.packages('ggplot2').")
    }
    if (is.null(plot_title)) {
      plot_title <- "Canopy Height Raster"
    }
    stopifnot(is.character(plot_title))
    plot_df <- raster

    out$plot <- ggplot2::ggplot(plot_df, ggplot2::aes(x = .data$x, y = .data$y, fill = .data$z)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_gradientn(
        colours = grDevices::hcl.colors(100, "viridis"),
        name    = "Canopy Height (m)"
      ) +
      ggplot2::coord_equal() +
      ggplot2::labs(title = plot_title, x = "X", y = "Y") +
      ggplot2::theme_minimal()
  }
  out
}
