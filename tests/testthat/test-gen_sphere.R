test_that("gen_sphere returns pt_cld", {
  sphere <- gen_sphere(1, 0.5)
  expect_s3_class(sphere, "pt_cld")
  expect_equal(ncol(sphere), 3)
  expect_equal(colnames(sphere), c("x", "y", "z"))
})

test_that("gen_sphere respects radius", {
  sphere <- gen_sphere(1, 0.1)
  dists <- sqrt(rowSums(sphere^2))
  expect_true(all(dists <= 1 + 0.1))
})

test_that("gen_sphere respects center offset", {
  center <- c(5, 10, 15)
  sphere <- gen_sphere(1, 0.5, center)
  expect_true(all(sphere$x >= 4))
  expect_true(all(sphere$y >= 9))
  expect_true(all(sphere$z >= 14))
})

test_that("gen_sphere with smaller res produces more points", {
  s1 <- gen_sphere(1, 0.5)
  s2 <- gen_sphere(1, 0.1)
  expect_true(nrow(s2) > nrow(s1))
})
