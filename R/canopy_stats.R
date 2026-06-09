#' Compute canopy height statistics from a point cloud.
#'
#' Calculate various canopy height statistics from a point cloud rasterized
#' to a grid. The cloud is snapped to a regular grid and the maximum height
#' per cell is extracted. Heights are computed relative to the minimum z value
#' in the input cloud so vertical offsets do not affect the statistics.
#'
#' @param cloud A `pt_cld` object. Use [as_pt_cld()] to convert.
#' @param res Numeric of the grid resolution for rasterization.
#' @param lower_cutoff Numeric of the minimum canopy height threshold. Cells
#' whose maximum height does not exceed this value are treated as empty for
#' statistics, openness, and plotting.
#' @param plot Logical controlling whether to plot the rasterized canopy height
#' grid. Defaults to FALSE.
#' @param plot_title Character string for the plot title. Only used when
#' `plot = TRUE`. Defaults to "Canopy Height Raster".
#' @param footprint Optional character string describing the footprint geometry
#' used for the openness calculation. Allowed values are `"rect"` and
#' `"circ"`. `"rect"` uses the full raster extent. `"circ"` limits
#' openness to cells inside a circle centered on the raster extent. If
#' `NULL` (default), `"rect"` is used unless `radius` is supplied, in
#' which case `"circ"` is assumed.
#' @param radius Optional numeric radius for a circular footprint. A radius
#' must be supplied whenever `footprint = "circ"`.
#'
#' @return A list with elements "max", "mean", "sd", "cv" (coefficient of
#' variation), "gini" (Gini coefficient), "openness" (proportion of empty
#' cells inside the selected footprint as a value between 0 and 1), and "grid" (the
#' rasterized height matrix). If `plot = TRUE`, an additional "plot" element
#' containing a ggplot object is included. The plot legend title displays the
#' canopy statistics using HTML-formatted text via `ggtext`.
#'
#' @importFrom rlang .data
#' @importFrom ggtext element_markdown
#' @export
#' @examples
#' \dontrun{
#' sphere <- gen_sphere(1, 0.01)
#' stats <- canopy_stats(sphere, res = 0.1, lower_cutoff = 0.5, plot = FALSE)
#' circular_stats <- canopy_stats(sphere, res = 0.1, footprint = "circ", radius = 1)
#' }
#'
canopy_stats <- function(
  cloud,
  res,
  lower_cutoff = NULL,
  plot = FALSE,
  plot_title = NULL,
  footprint = NULL,
  radius = NULL
) {
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
  if (is.null(footprint)) {
    footprint <- if (is.null(radius)) "rect" else "circ"
  } else {
    footprint <- match.arg(footprint, c("rect", "circ"))
  }
  if (footprint == "circ" && is.null(radius)) {
    stop("radius must be supplied when footprint = \"circ\".")
  }
  if (!is.null(radius)) {
    if (!is.numeric(radius) || length(radius) != 1 || !is.finite(radius) || radius <= 0) {
      stop("radius must be a single positive numeric value.")
    }
    if (footprint != "circ") {
      stop("radius can only be used when footprint = \"circ\".")
    }
  }

  .validate_pt_cld(cloud)

  x_vox <- .round_n(cloud[, "x"], res)
  y_vox <- .round_n(cloud[, "y"], res)
  z <- cloud[, "z"] - min(cloud[, "z"])

  cells <- data.frame(x = x_vox, y = y_vox, z = z)
  full_raster <- stats::aggregate(z ~ x + y, data = cells, FUN = max)
  raster <- full_raster

  if (!is.null(lower_cutoff)) {
    raster <- raster[raster$z > lower_cutoff, , drop = FALSE]
  }
  canopy_heights <- raster$z

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

  xi <- sort(unique(full_raster$x))
  yi <- sort(unique(full_raster$y))
  grid <- matrix(NA,
    nrow = length(yi), ncol = length(xi),
    dimnames = list(yi, xi)
  )
  for (i in seq_len(nrow(raster))) {
    grid[as.character(raster$y[i]), as.character(raster$x[i])] <- raster$z[i]
  }

  openness_mask <- matrix(
    TRUE,
    nrow = length(yi), ncol = length(xi),
    dimnames = list(yi, xi)
  )
  if (footprint == "circ") {
    center_x <- mean(range(xi))
    center_y <- mean(range(yi))
    circle_radius <- radius
    openness_mask <- outer(
      yi,
      xi,
      FUN = function(y, x) {
        (x - center_x)^2 + (y - center_y)^2 <= circle_radius^2 + sqrt(.Machine$double.eps)
      }
    )
  }

  n_footprint_cells <- sum(openness_mask)
  if (n_footprint_cells == 0) {
    stop("The selected footprint does not include any raster cells.")
  }
  out$openness <- sum(is.na(grid)[openness_mask]) / n_footprint_cells
  out$grid <- grid

  if (plot) {
    if (is.null(plot_title)) {
      plot_title <- "Canopy Height Raster"
    }
    stopifnot(is.character(plot_title))
    plot_df <- raster

    stat_label <- paste0(
      "<b>Max:</b> ",      round(out$max, 2), "<br>",
      "<b>Mean:</b> ",     round(out$mean, 2), "<br>",
      "<b>SD:</b> ",       round(out$sd, 2), "<br>",
      "<b>CV:</b> ",       round(out$cv, 2), "<br>",
      "<b>Gini:</b> ",     round(out$gini, 2), "<br>",
      "<b>Openness:</b> ", round(out$openness * 100, 1), "%<br><br>",
      "<span style='font-size:12pt'><b>Canopy Height (m)</b></span>"
    )

    out$plot <- ggplot2::ggplot(plot_df, ggplot2::aes(x = .data$x, y = .data$y, fill = .data$z)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_gradientn(
        colours = grDevices::hcl.colors(100, "viridis"),
        name    = stat_label
      ) +
      ggplot2::coord_equal() +
      ggplot2::labs(title = plot_title, x = "X", y = "Y") +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.title = ggtext::element_markdown(size = 11, lineheight = 1.5))
  }
  out
}
