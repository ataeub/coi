test_that("coi returns numeric value", {
  s1 <- gen_sphere(0.5, 0.01, c(-0.2, 0, 0))
  s2 <- gen_sphere(0.5, 0.01, c(0.2, 0, 0))
  result <- coi(s1, s2, d_max = 0.1, vox_res = 0.05)
  expect_true(is.numeric(result))
  expect_length(result, 1)
  expect_true(result >= 0)
})

test_that("coi of identical spheres at same position warns", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(0, 0, 0))
  expect_warning(
    result <- coi(s1, s2, d_max = 0.3, vox_res = 0.1),
    "All measured distances equal 0"
  )
  expect_true(result >= 0)
})

test_that("coi of distant spheres warns about no overlap", {
  s1 <- gen_sphere(0.5, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(0.5, 0.05, c(10, 0, 0))
  expect_warning(
    result <- coi(s1, s2, d_max = 0.3, vox_res = 0.1),
    "No overlap detected"
  )
  expect_equal(result, 0)
})

test_that("coi warns when vox_res is NULL", {
  s1 <- gen_sphere(1, 0.1)
  s2 <- gen_sphere(1, 0.1, c(0, 0.5, 0))
  expect_warning(
    coi(s1, s2, d_max = 0.5, vox_res = NULL),
    "vox_res left undefined"
  )
})

test_that("coi rejects non-pt_cld input", {
  mat <- matrix(runif(30), ncol = 3)
  s <- gen_sphere(1, 0.1)
  expect_error(coi(mat, s, 0.3), "must be a pt_cld object")
})
