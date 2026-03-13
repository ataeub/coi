test_that("clip_z from bottom removes low points", {
  cloud <- gen_sphere(5, 0.5)
  z_min <- min(cloud[, "z"])
  clip_len <- 2
  result <- clip_z(cloud, clip_len, from_top = FALSE)
  expect_true(min(result[, "z"]) >= z_min + clip_len)
  expect_true(nrow(result) < nrow(cloud))
})

test_that("clip_z from top removes high points", {
  cloud <- gen_sphere(5, 0.5)
  z_max <- max(cloud[, "z"])
  clip_len <- 2
  result <- clip_z(cloud, clip_len, from_top = TRUE)
  expect_true(max(result[, "z"]) <= z_max - clip_len)
  expect_true(nrow(result) < nrow(cloud))
})

test_that("clip_z returns pt_cld", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_z(cloud, 1)
  expect_true(is_pt_cld(result))
})

test_that("clip_z with zero length preserves all points", {
  cloud <- gen_sphere(1, 0.1)
  result <- clip_z(cloud, 0, from_top = FALSE)
  expect_equal(nrow(result), nrow(cloud))
})

test_that("clip_z rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(clip_z(mat, 1), "pt_cld")
})
