test_that("clip_rect returns pt_cld", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_rect(cloud, dim_x = 4)
  expect_true(is_pt_cld(result))
})

test_that("clip_rect reduces point count", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_rect(cloud, dim_x = 4)
  expect_true(nrow(result) < nrow(cloud))
})

test_that("clip_rect clips to correct x bounds with center origin", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_rect(cloud, dim_x = 4, center = "origin")
  expect_true(all(abs(result[, "x"]) <= 2))
  expect_true(all(abs(result[, "y"]) <= 2))
})

test_that("clip_rect supports rectangular clips", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_rect(cloud, dim_x = 6, dim_y = 2, center = "origin")
  expect_true(all(abs(result[, "x"]) <= 3))
  expect_true(all(abs(result[, "y"]) <= 1))
})

test_that("clip_rect supports numeric center", {
  cloud <- gen_sphere(5, 0.5)
  result <- clip_rect(cloud, dim_x = 4, center = c(0, 0))
  expect_true(is_pt_cld(result))
  expect_true(all(abs(result[, "x"]) <= 2))
})

test_that("clip_rect preserves all points when clip is larger than cloud", {
  cloud <- gen_sphere(1, 0.1)
  result <- clip_rect(cloud, dim_x = 100, center = "center")
  expect_equal(nrow(result), nrow(cloud))
})

test_that("clip_rect rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(clip_rect(mat, dim_x = 1), "pt_cld")
})
