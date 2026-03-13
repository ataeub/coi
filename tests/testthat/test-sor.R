test_that("sor removes outliers", {
  sphere <- gen_sphere(1, 0.05)
  outliers <- pt_cld(c(5, -5), c(5, -5), c(5, -5))
  noisy <- rbind(sphere, outliers)
  cleaned <- sor(noisy, n = 10, s = 1)
  expect_true(nrow(cleaned) < nrow(noisy))
})

test_that("sor returns pt_cld", {
  sphere <- gen_sphere(1, 0.05)
  outliers <- pt_cld(c(5), c(5), c(5))
  noisy <- rbind(sphere, outliers)
  result <- sor(noisy, n = 5, s = 1)
  expect_true(is_pt_cld(result))
})

test_that("sor with high s keeps all points", {
  sphere <- gen_sphere(1, 0.05)
  result <- sor(sphere, n = 5, s = 100)
  expect_equal(nrow(result), nrow(sphere))
})

test_that("sor rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(sor(mat, n = 5, s = 1), "pt_cld")
})

test_that("sor rejects negative s", {
  sphere <- gen_sphere(1, 0.05)
  expect_error(sor(sphere, n = 5, s = -1))
})
