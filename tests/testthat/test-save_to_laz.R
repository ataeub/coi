test_that("save_to_laz rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(save_to_laz(mat, tempfile(fileext = ".laz")), "pt_cld")
})

test_that("save_to_laz requires rlas", {
  skip_if_not_installed("rlas")
  cloud <- gen_sphere(1, 0.1)
  f <- tempfile(fileext = ".laz")
  on.exit(unlink(f), add = TRUE)
  expect_no_error(save_to_laz(cloud, f))
  expect_true(file.exists(f))
})
