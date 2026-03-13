test_that("cci of identical spheres is 0", {
  s1 <- gen_sphere(2, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(2, 0.05, c(0, 0, 0))
  result <- cci(s1, s2, strata_size = 0.2, hull_type = "convex", vox_res = 0.1,
                warnings = FALSE)
  expect_equal(result, 0)
})

test_that("cci of different-sized spheres is > 0", {
  s1 <- gen_sphere(2, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(3, 0.05, c(0, 0, 0))
  result <- cci(s1, s2, strata_size = 0.2, hull_type = "convex", vox_res = 0.1,
                warnings = FALSE)
  expect_true(result > 0)
  expect_true(result <= 1)
})

test_that("cci returns numeric scalar", {
  s1 <- gen_sphere(1, 0.05)
  s2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
  result <- cci(s1, s2, strata_size = 0.3, hull_type = "convex", vox_res = 0.1,
                warnings = FALSE)
  expect_true(is.numeric(result))
  expect_length(result, 1)
})

test_that("cci rejects non-pt_cld input", {
  mat <- matrix(runif(30), ncol = 3)
  s <- gen_sphere(1, 0.1)
  expect_error(cci(mat, s, 0.3, "convex", 0.1, warnings = FALSE),
               "must be a pt_cld object")
})

test_that("cci warns when vox_res is NULL", {
  s1 <- gen_sphere(1, 0.1)
  s2 <- gen_sphere(1, 0.1, c(0, 0.5, 0))
  expect_warning(
    cci(s1, s2, 0.3, "convex", vox_res = NULL, warnings = TRUE),
    "vox_res left undefined"
  )
})
