#' Compute the box dimension structural complexity index for a given point
#' cloud.
#'
#' Calculate the box dimension as described in Seidel et al. (2018)
#'
#' @param cloud A `pt_cld` object (see [as_pt_cld()]).
#' @param threshold The lower resolution threshold until which the box dimension
#' algorithm iterates
#' @param vox_res Numeric of the resolution for voxelization. If left undefined
#' (default), the raw cloud will be analzed, which should only be done if the
#' cloud has been voxelized before independently.
#' @param warnings Logical controlling whether to display a warning when vox_res
#' is left undefined. Defaults to TRUE.
#' @param plot Logical. If TRUE, a ggplot of the log-log regression is
#' included in the output. Defaults to FALSE.
#' @param plot_title Optional character string for the plot title.
#' @return If `plot = FALSE` (default), a numeric representing the box dimension.
#' If `plot = TRUE`, a named list with elements `boxdim` (the box dimension)
#' and `plot` (a ggplot object).
#' @export
#' @examples
#' sphere <- gen_sphere(1, 0.01, c(0, 0, 0))
#' boxdim(sphere, 0.1, 0.05)
boxdim <- function(
  cloud,
  threshold,
  vox_res = NULL,
  plot = FALSE,
  plot_title = NULL,
  warnings = TRUE
) {
  .validate_pt_cld(cloud)

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

  if (plot) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Package 'ggplot2' is required for plotting. Install it with install.packages('ggplot2').")
    }
    if (is.null(plot_title)) {
      plot_title <- "Box dimension log-log regression"
    }
    df <- data.frame(x = x[, 2], y = y)
    fit_df <- data.frame(
      x = range(df$x),
      y = coef[1] + coef[2] * range(df$x)
    )
    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$x, y = .data$y)) +
      ggplot2::geom_point(size = 2) +
      ggplot2::geom_line(data = fit_df, ggplot2::aes(
        x = .data$x, y = .data$y
      ), color = "steelblue", linewidth = 1) +
      ggplot2::labs(
        x = "log(1 / box size)",
        y = "log(N boxes)",
        title = plot_title,
        subtitle = sprintf("Slope (box dimension) = %.3f", slope)
      ) +
      ggplot2::theme_minimal()
    return(list(boxdim = slope, plot = p))
  }
  slope
}
