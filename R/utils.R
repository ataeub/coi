# Calculate cloud to cloud distances for every point of a query cloud to the
# respective nearest points of the reference cloud with a kd-tree using the
# `RANN::nn2()` function.
#
# @param cloud_query The queried cloud as a matrix-like object, whose points
# will be labelled with the distance to the nearest point of the reference
# cloud.
# @param cloud_ref The reference cloud as a matrix-like object, whose points
# the query cloud will be compared against.
# @param cloud_ref The reference cloud as a matrix-like object, whose points
# the query cloud will be compared against.
# @param max_dist Numeric of an optional maximum distance for the
# calculation. Points above this threshold will be discarded.
# @returns Matrix of cloud_query with an additional column named "distance" 
# with the distances per point to cloud_ref
# @export
# @examples
# sphere1 <- gen_sphere(1, 0.1, c(0, 0, 0))
# sphere2 <- gen_sphere(1, 0.1, c(0, 0.5, 0))
# coi:::.calculate_c2c_dist(sphere1, sphere2, max_dist = 0.5)
.calculate_c2c_dist <- function(
  cloud_query,
  cloud_ref,
  max_dist = NULL
) {
  nn <- RANN::nn2(
    data = cloud_ref,
    query = cloud_query,
    k = 1,
    searchtype = "standard"
  )

  out_cloud <- cloud_query
  out_cloud <- cbind(out_cloud, distance = nn$nn.dists[, 1])
  if (!is.null(max_dist) && is.numeric(max_dist)) {
    # finite check because apparently if nn2 fails it will output
    # non-finite results
    out_cloud <- out_cloud[
      is.finite(out_cloud[, "distance"]) &
        out_cloud[, "distance"] <= max_dist,
    ]
  } else {
    stop("max_dist must be number or NULL.")
  }
  out_cloud
}

# Bin z-coordinates of a point cloud to a given resolution.
#
# For CCI calculation vertical strata need to be created. This function does
# this by rounding only the z-coordinate of clouds to multiples of the strata
# resolution.
#
# @param cloud Pointcloud as a 3 column matrix with column names "x", "y", "z".
# Use cloud_to_mat() to get this format.
# @param strata_size Numeric of the resolution of vertical (z-axis) strata.
# @returns The point cloud as a three column matrix with column names
# "x", "y", "z", with z-axis binned to the given resolution.
# @examples
# sphere <- gen_sphere(1, 0.01)
# coi:::.stratify(sphere, 0.05)
.stratify <- function(cloud, strata_size) {
  cloud_s <- cloud |>
    .round_n(strata_size) |>
    unique()
  idx <- split(seq_len(nrow(cloud_s)), cloud_s[, "z"])
  strata <- lapply(idx, function(i) cloud_s[i, , drop = FALSE])
  strata
}

# Round a numeric variable to multiples of a given number.
#
# @param x Numeric to round.
# @param n Numeric of multiple to round `x` to.
# @returns Numeric with `x` rounded to multiple of `n`
# @examples
# num <- 4.54
# coi:::.round_n(num, 0.1)
.round_n <- function(x, n) {
  round(x / n) * n
}

# Check if a list of point clouds representing layers is equal to a given
# length and add empty layers if it is shorter.
#
# @param layers A list of matrices representing point clouds.
# @param max_height The length to compare the lists length against.
# @returns A list of matrices representing point clouds with empty matrices
# added if list was shorter than `max_height`.
# @examples
# list1 <- rep(list(gen_sphere(1, 0.5)), 3)
# list2 <- rep(list(gen_sphere(1, 0.5)), 5)
# max_length <- max(length(list1), length(list2))
# list1 <- coi:::.pad_layers(list1, max_length)
# list2 <- coi:::.pad_layers(list2, max_length)
.pad_layers <- function(layers, max_height) {
  if (length(layers) < max_height) {
    n_missing <- max_height - length(layers)
    empty_mat <- matrix(numeric(0), nrow = 0, ncol = 3)
    colnames(empty_mat) <- c("x", "y", "z")
    layers <- c(layers, rep(list(empty_mat), n_missing))
  }
  layers
}

# Calculate the x-y-area of a point cloud by extracting the concave or convex
# hull and applying the shoelace algorithm.
#
# @param stratum Point cloud as a matrix-like object
# @param hull_type String of the type of hull algorithm. "concave" (default) or
# "convex"
# @returns Numeric of the area of the given point cloud in x-y dimension
# @examples
# sphere_3d <- gen_sphere(1, 0.05)
# coi:::.get_stratum_area(sphere_3d, "convex")
.get_stratum_area <- function(stratum, hull_type = c("concave", "convex")) {
  if (nrow(stratum) < 3) {
    return(0)
  }
  stratum <- stratum[, c("x", "y"), drop = FALSE]
  hull_type <- match.arg(hull_type)
  hull_points <- .hullify(stratum, type = hull_type)
  if (nrow(hull_points) < 3) {
    return(0)
  }
  area <- .shoelace(hull_points)
  area
}

# Extract the concave or convex hull for a 2-dimensional point cloud.
#
# @param points Matrix with the 2-D points to extract the hull from.
# @param type String of the type of hull algorithm. "concave" (default) or
# "convex".
# @param warnings Logic whether to show warning when less than 3 points were
# extracted.
# @returns A Matrix with the points that make up the hull.
# @examples
# sphere_3d <- gen_sphere(1, 0.05)
# coi:::.hullify(sphere_3d, "convex")
.hullify <- function(points, type = c("concave", "convex"), warnings = FALSE) {
  type <- match.arg(type)
  if (dim(points)[2] != 2) {
    stop("Points are not two-dimensional!")
  }

  if (type == "concave") {
    hull_points <- concaveman::concaveman(points)
  } else if (type == "convex") {
    hull_points <- points[grDevices::chull(points), ]
  }

  if (warnings && nrow(hull_points) < 3) {
    warning("Extracted hull has less than 3 points!")
  }
  colnames(hull_points) <- c("x", "y")
  hull_points
}

# Apply the shoelace algorithm to a set of 2-D hull points to extract the area.
#
# @param points Matrix with the hull points to compute the area from.
# @return Numeric of the area of the hull.
# @examples
# sphere_3d <- gen_sphere(1, 0.05)
# hull <- .hullify(sphere_3d, "convex")
# coi:::.shoelace(hull)
.shoelace <- function(points) {
  if (dim(points)[2] != 2) {
    stop("Points are not two-dimensional!")
  }
  if (nrow(points) < 3) {
    stop(
      "Less than 3 points were provided! Can only compute area for >3 points."
    )
  }
  stopifnot()
  x <- points[, "x"]
  y <- points[, "y"]
  area <- 0.5 * abs(sum(x[-1] * y[-length(y)] - x[-length(x)] * y[-1]))
  area
}
