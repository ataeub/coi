test_that("voxelize returns pt_cld", {
  sphere <- gen_sphere(1, 0.01)
  vox <- voxelize(sphere, 0.1)
  expect_s3_class(vox, "pt_cld")
})

test_that("voxelize reduces point count", {
  sphere <- gen_sphere(1, 0.01)
  vox <- voxelize(sphere, 0.1)
  expect_true(nrow(vox) < nrow(sphere))
})

test_that("voxelize with same resolution is idempotent", {
  sphere <- gen_sphere(1, 0.1)
  vox1 <- voxelize(sphere, 0.1)
  vox2 <- voxelize(vox1, 0.1)
  expect_equal(nrow(vox1), nrow(vox2))
})

test_that("voxelize rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(voxelize(mat, 0.1), "must be a pt_cld object")
})
