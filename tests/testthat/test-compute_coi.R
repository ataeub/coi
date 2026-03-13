test_that("compute_coi returns numeric", {
  s1 <- gen_sphere(1, 0.05, c(0, 0, 0))
  s2 <- gen_sphere(1, 0.05, c(0, 0.5, 0))
  s1v <- voxelize(s1, 0.1)
  s2v <- voxelize(s2, 0.1)
  d_max <- 0.3
  dists <- extract_interaction(s1v, s2v, d_max)
  total <- nrow(s1v) + nrow(s2v)
  result <- compute_coi(dists, total, d_max)
  expect_true(is.numeric(result))
  expect_length(result, 1)
  expect_true(result >= 0)
})

test_that("compute_coi errors on negative distances", {
  expect_error(compute_coi(c(-1, 0.5), 100, 1), "Negative distances")
})

test_that("compute_coi warns on all-zero distances", {
  expect_warning(compute_coi(c(0, 0, 0), 100, 1), "All measured distances equal 0")
})
