test_that("extract_dtm returns mesh3d", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  cloud <- gen_sphere(5, 0.5)
  dtm <- extract_dtm(cloud, res = 2)
  expect_true(inherits(dtm, "mesh3d"))
})

test_that("extract_dtm mesh has vertices and faces", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  cloud <- gen_sphere(5, 0.5)
  dtm <- extract_dtm(cloud, res = 2)
  expect_true(ncol(dtm$vb) > 0)
  expect_true(ncol(dtm$it) > 0)
})

test_that("extract_dtm rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(extract_dtm(mat, res = 1), "pt_cld")
})
