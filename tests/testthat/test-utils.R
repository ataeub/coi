# ---- .calculate_c2c_dist ----

test_that(".calculate_c2c_dist returns matrix with distance column", {
  s1 <- gen_sphere(1, 0.1, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.1, c(0, 0.5, 0))
  result <- coi:::.calculate_c2c_dist(s1, s2, max_dist = 0.5)
  expect_true(is.matrix(result))
  expect_true("distance" %in% colnames(result))
  expect_true(all(result[, "distance"] <= 0.5))
})

test_that(".calculate_c2c_dist rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  s <- gen_sphere(1, 0.1)
  expect_error(coi:::.calculate_c2c_dist(mat, s, 0.5), "must be a pt_cld object")
})

# ---- .stratify ----

test_that(".stratify returns list of matrices", {
  sphere <- gen_sphere(1, 0.1)
  strata <- coi:::.stratify(sphere, 0.5)
  expect_true(is.list(strata))
  expect_true(length(strata) > 1)
  expect_true(all(sapply(strata, is.matrix)))
})

test_that(".stratify elements have xyz columns", {
  sphere <- gen_sphere(1, 0.1)
  strata <- coi:::.stratify(sphere, 0.5)
  for (s in strata) {
    expect_equal(colnames(s), c("x", "y", "z"))
  }
})

# ---- .round_n ----

test_that(".round_n rounds to multiples", {
  expect_equal(coi:::.round_n(4.54, 0.1), 4.5)
  expect_equal(coi:::.round_n(4.56, 0.1), 4.6)
  expect_equal(coi:::.round_n(7, 5), 5)
  expect_equal(coi:::.round_n(8, 5), 10)
})

# ---- .pad_layers ----

test_that(".pad_layers extends short list", {
  layers <- list(matrix(1:6, ncol = 3), matrix(7:12, ncol = 3))
  padded <- coi:::.pad_layers(layers, 5)
  expect_length(padded, 5)
  expect_equal(nrow(padded[[5]]), 0)
  expect_equal(colnames(padded[[5]]), c("x", "y", "z"))
})

test_that(".pad_layers leaves long enough list unchanged", {
  layers <- list(matrix(1:6, ncol = 3), matrix(7:12, ncol = 3))
  padded <- coi:::.pad_layers(layers, 2)
  expect_length(padded, 2)
})

# ---- .get_stratum_area ----

test_that(".get_stratum_area returns 0 for < 3 points", {
  small <- pt_cld(c(0, 1), c(0, 1), c(0, 0))
  area <- coi:::.get_stratum_area(small, "convex")
  expect_equal(area, 0)
})

test_that(".get_stratum_area returns positive area for a square", {
  # 4 points forming a unit square in XY at z = 0
  square <- pt_cld(c(0, 1, 1, 0), c(0, 0, 1, 1), c(0, 0, 0, 0))
  area <- coi:::.get_stratum_area(square, "convex")
  expect_true(area > 0)
  expect_equal(area, 1, tolerance = 0.01)
})

# ---- .shoelace ----

test_that(".shoelace computes correct area for unit square", {
  points <- matrix(c(0, 1, 1, 0, 0, 0, 1, 1), ncol = 2)
  colnames(points) <- c("x", "y")
  area <- coi:::.shoelace(points)
  expect_equal(area, 1, tolerance = 0.001)
})

test_that(".shoelace computes correct area for triangle", {
  # Square with edge length 1 should equal 1 area unit
  points <- matrix(c(0, 1, 1, 0, 0, 0, 1, 1), ncol = 2)
  colnames(points) <- c("x", "y")
  area <- coi:::.shoelace(points)
  expect_equal(area, 1)
})

test_that(".shoelace rejects non-2D input", {
  points <- matrix(1:9, ncol = 3)
  expect_error(coi:::.shoelace(points), "not two-dimensional")
})
