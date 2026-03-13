test_that("z_normalize returns pt_cld", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  cloud <- gen_sphere(5, 0.5)
  dtm <- extract_dtm(cloud, res = 2)
  clipped <- clip_rect(cloud, 4, center = "center")
  result <- z_normalize(clipped, dtm = dtm)
  expect_true(is_pt_cld(result))
  expect_equal(nrow(result), nrow(clipped))
})

test_that("z_normalize shifts z towards zero", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  # Create a cloud elevated above ground
  grid <- expand.grid(x = seq(0, 10, 0.5), y = seq(0, 10, 0.5))
  grid$z <- 5 # flat plane at z = 5
  cloud <- as_pt_cld(grid)
  dtm <- extract_dtm(cloud, res = 2)
  clipped <- clip_rect(cloud, 8, center = "center")
  result <- z_normalize(clipped, dtm = dtm)
  # Normalized z should be near zero
  expect_true(abs(mean(result[, "z"])) < 1)
})

test_that("z_normalize errors without res or dtm", {
  cloud <- gen_sphere(1, 0.1)
  expect_error(z_normalize(cloud), "Either `res` or `dtm`")
})

test_that("z_normalize rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(z_normalize(mat, res = 1), "pt_cld")
})
