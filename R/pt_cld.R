# ---- Constructor ----

#' Create a point cloud object
#'
#' Creates a `pt_cld` object from a matrix, data.frame, or individual x, y, z
#' vectors. This is the standard point cloud format used throughout this
#' package.
#'
#' @param x A matrix or data.frame with at least 3 columns (x, y, z), or a
#'   numeric vector of x-coordinates when `y` and `z` are also provided.
#' @param y Numeric vector of y-coordinates. Only used when `x` is a vector.
#' @param z Numeric vector of z-coordinates. Only used when `x` is a vector.
#' @return A `pt_cld` object: a 3-column numeric matrix with columns
#'   "x", "y", "z".
#' @export
#' @examples
#' # From vectors
#' cloud <- pt_cld(1:10, 11:20, 21:30)
#'
#' # From a data.frame
#' df <- data.frame(x = 1:10, y = 11:20, z = 21:30)
#' cloud <- pt_cld(df)
#'
#' # From a matrix
#' mat <- matrix(runif(30), ncol = 3)
#' cloud <- pt_cld(mat)
pt_cld <- function(x, y = NULL, z = NULL) {
  if (!is.null(y) && !is.null(z)) {
    if (!is.numeric(x) || !is.numeric(y) || !is.numeric(z)) {
      stop("x, y, and z must be numeric vectors.")
    }
    if (length(x) != length(y) || length(x) != length(z)) {
      stop("x, y, and z must have the same length.")
    }
    mat <- cbind(x = x, y = y, z = z)
  } else if (is.null(y) && is.null(z)) {
    if (is.data.frame(x)) {
      x <- as.matrix(x)
    }
    if (!is.matrix(x)) {
      stop("x must be a matrix, data.frame, or provide x, y, z vectors.")
    }
    if (ncol(x) < 3) {
      stop("Input must have at least 3 columns (x, y, z).")
    }
    mat <- x[, 1:3, drop = FALSE]
    colnames(mat) <- c("x", "y", "z")
  } else {
    stop("Provide either a matrix/data.frame as x, or all three: x, y, z.")
  }

  storage.mode(mat) <- "numeric"

  if (any(is.na(mat))) {
    stop("Point cloud contains NAs.")
  }

  class(mat) <- c("pt_cld", "matrix", "array")
  mat
}

# ---- Coercion generic ----

#' Convert an object to a point cloud
#'
#' Generic function to convert various objects to a `pt_cld` point cloud object.
#'
#' @param x Object to convert.
#' @param ... Additional arguments passed to methods.
#' @return A `pt_cld` object.
#' @export
#' @examples
#' df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
#' cloud <- as_pt_cld(df)
as_pt_cld <- function(x, ...) {
  UseMethod("as_pt_cld")
}

#' @rdname as_pt_cld
#' @export
as_pt_cld.pt_cld <- function(x, ...) {
  x
}

#' @rdname as_pt_cld
#' @export
as_pt_cld.matrix <- function(x, ...) {
  pt_cld(x)
}

#' @rdname as_pt_cld
#' @export
as_pt_cld.data.frame <- function(x, ...) {
  pt_cld(x)
}

#' @rdname as_pt_cld
#' @export
as_pt_cld.default <- function(x, ...) {
  stop(
    "Cannot convert object of class '", paste(class(x), collapse = "/"),
    "' to pt_cld. Provide a matrix or data.frame with x, y, z columns."
  )
}

# ---- Validator ----

#' Check if an object is a pt_cld
#'
#' @param x Object to test.
#' @return Logical: `TRUE` if `x` inherits from `pt_cld`, `FALSE` otherwise.
#' @export
#' @examples
#' cloud <- gen_sphere(1, 0.5)
#' is_pt_cld(cloud)
is_pt_cld <- function(x) {
  inherits(x, "pt_cld")
}

# Internal validator called at the top of functions requiring a pt_cld.
.validate_pt_cld <- function(cloud, arg_name = "cloud") {
  if (!is_pt_cld(cloud)) {
    stop(
      "'", arg_name, "' must be a pt_cld object. Use as_pt_cld() to convert.",
      call. = FALSE
    )
  }
  invisible(NULL)
}

# ---- S3 methods ----

#' @export
print.pt_cld <- function(x, ...) {
  n <- nrow(x)
  cat("pt_cld with", format(n, big.mark = ","), "points\n")
  if (n > 0) {
    mins <- round(apply(x, 2, min), 3)
    maxs <- round(apply(x, 2, max), 3)
    cat("  x: [", mins["x"], ", ", maxs["x"], "]\n", sep = "")
    cat("  y: [", mins["y"], ", ", maxs["y"], "]\n", sep = "")
    cat("  z: [", mins["z"], ", ", maxs["z"], "]\n", sep = "")
  }
  invisible(x)
}

#' @export
summary.pt_cld <- function(object, ...) {
  n <- nrow(object)
  cat("pt_cld with", format(n, big.mark = ","), "points\n\n")
  if (n > 0) {
    stats <- data.frame(
      min = apply(object, 2, min),
      mean = apply(object, 2, mean),
      max = apply(object, 2, max),
      sd = apply(object, 2, stats::sd)
    )
    print(round(stats, 4))
  }
  invisible(object)
}

#' @export
plot.pt_cld <- function(x, ...) {
  z_vals <- x[, "z"]
  z_range <- range(z_vals)
  if (z_range[1] == z_range[2]) {
    cols <- rep("black", nrow(x))
  } else {
    z_scaled <- (z_vals - z_range[1]) / (z_range[2] - z_range[1])
    cols <- grDevices::hcl.colors(256, "viridis")[
      pmax(1, ceiling(z_scaled * 255) + 1)
    ]
  }
  plot(
    x[, "x"], x[, "y"],
    col = cols, pch = ".", asp = 1,
    xlab = "x", ylab = "y",
    main = paste("pt_cld |", format(nrow(x), big.mark = ","), "points"),
    ...
  )
  invisible(x)
}

#' @export
`$.pt_cld` <- function(x, name) {
  if (name %in% c("x", "y", "z")) {
    return(unclass(x)[, name])
  }
  stop("pt_cld objects only have $x, $y, and $z.", call. = FALSE)
}

#' @export
`[.pt_cld` <- function(x, i, j, ..., drop = FALSE) {
  mat <- unclass(x)
  result <- mat[i, j, ..., drop = drop]
  # Preserve class only when result is still a valid 3-col xyz matrix
  if (is.matrix(result) && ncol(result) == 3) {
    cn <- colnames(result)
    if (!is.null(cn) && identical(cn, c("x", "y", "z"))) {
      class(result) <- c("pt_cld", "matrix", "array")
    }
  }
  result
}

#' @export
rbind.pt_cld <- function(...) {
  clouds <- list(...)
  mats <- lapply(clouds, unclass)
  combined <- do.call(rbind, mats)
  pt_cld(combined)
}
