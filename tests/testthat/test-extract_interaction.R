test_that("extract_interaction returns distances by default", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
  dists <- extract_interaction(s1, s2, d_max = 0.5)
  expect_true(is.numeric(dists))
  expect_true(length(dists) > 0)
  expect_true(all(dists >= 0))
  expect_true(all(dists <= 0.5))
})

test_that("extract_interaction returns cloud with distance column", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
  cloud <- extract_interaction(s1, s2, d_max = 0.5, returns = "cloud")
  expect_true(is.matrix(cloud))
  expect_true("distance" %in% colnames(cloud))
  expect_equal(ncol(cloud), 4)
})

test_that("extract_interaction rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  s <- gen_sphere(1, 0.1)
  expect_error(extract_interaction(mat, s, 0.5), "must be a pt_cld object")
  expect_error(extract_interaction(s, mat, 0.5), "must be a pt_cld object")
})

test_that("extract_interaction with no overlap returns empty", {
  s1 <- gen_sphere(0.5, 0.1, c(0, 0, 0))
  s2 <- gen_sphere(0.5, 0.1, c(10, 0, 0))
  dists <- extract_interaction(s1, s2, d_max = 0.5)
  expect_equal(length(dists), 0)
})
