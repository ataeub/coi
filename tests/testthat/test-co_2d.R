test_that("co_2d returns 1 for identical projected footprints", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(0, 0, 1))

  overlap <- co_2d(s1, s2, vox_res = 0.05, warnings = FALSE)

  expect_equal(overlap, 1)
})

test_that("co_2d returns 0 for non-overlapping projected footprints", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(3, 0, 0))

  overlap <- co_2d(s1, s2, vox_res = 0.05, warnings = FALSE)

  expect_equal(overlap, 0)
})

test_that("co_2d uses intersection over union of unique footprint cells", {
  s1 <- pt_cld(c(0, 1, 2), c(0, 0, 0), c(0, 0, 0))
  s2 <- pt_cld(c(1, 2, 3), c(0, 0, 0), c(1, 1, 1))

  overlap <- co_2d(s1, s2, warnings = FALSE)

  expect_equal(overlap, 0.5)
})

test_that("co_2d stays bounded by 1", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(1, 0, 0))

  overlap <- co_2d(s1, s2, vox_res = 0.05, warnings = FALSE)

  expect_true(overlap >= 0)
  expect_true(overlap <= 1)
})

test_that("co_2d warns when vox_res is NULL", {
  s1 <- gen_sphere(1, 0.1)
  s2 <- gen_sphere(1, 0.1, c(0, 0.5, 0))

  expect_warning(
    co_2d(s1, s2, vox_res = NULL),
    "vox_res left undefined"
  )
})

test_that("co_2d rejects non-pt_cld input", {
  mat <- matrix(runif(30), ncol = 3)
  s <- gen_sphere(1, 0.1)

  expect_error(co_2d(mat, s), "must be a pt_cld object")
  expect_error(co_2d(s, mat), "must be a pt_cld object")
})