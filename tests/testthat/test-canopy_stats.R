test_that("canopy_stats returns expected list elements", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_type(result, "list")
  expect_true(all(c("max", "mean", "sd", "cv", "gini", "grid") %in% names(result)))
})

test_that("canopy_stats max >= mean", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_true(result$max >= result$mean)
})

test_that("canopy_stats with lower_cutoff filters heights", {
  sphere <- gen_sphere(1, 0.01)
  r1 <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  r2 <- canopy_stats(sphere, res = 0.1, lower_cutoff = 0.5, plot = FALSE)
  # With cutoff, mean should be higher (low values excluded)
  expect_true(r2$mean >= r1$mean)
})

test_that("canopy_stats warns when all heights below cutoff", {
  sphere <- gen_sphere(1, 0.01)
  expect_warning(
    canopy_stats(sphere, res = 0.1, lower_cutoff = 100, plot = FALSE),
    "No canopy heights"
  )
})

test_that("canopy_stats rejects invalid res", {
  sphere <- gen_sphere(1, 0.01)
  expect_error(canopy_stats(sphere, res = -1, plot = FALSE), "res must be")
  expect_error(canopy_stats(sphere, res = "a", plot = FALSE), "res must be")
})

test_that("canopy_stats rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(canopy_stats(mat, res = 0.1, plot = FALSE), "pt_cld")
})

test_that("canopy_stats grid is a matrix", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_true(is.matrix(result$grid))
})
