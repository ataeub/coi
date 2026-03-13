test_that("enl returns expected list elements without plot", {
  sphere <- gen_sphere(1, 0.01)
  result <- enl(sphere, voxel_res = 0.05, layer_thickness = 0.5, plot = FALSE)
  expect_type(result, "list")
  expect_true(all(c("ENL0", "ENL1", "ENL2") %in% names(result)))
})

test_that("enl values are positive", {
  sphere <- gen_sphere(1, 0.01)
  result <- enl(sphere, voxel_res = 0.05, layer_thickness = 0.5, plot = FALSE)
  expect_true(result$ENL0 > 0)
  expect_true(result$ENL1 > 0)
  expect_true(result$ENL2 > 0)
})

test_that("enl ENL0 is integer count of occupied layers", {
  sphere <- gen_sphere(1, 0.01)
  result <- enl(sphere, voxel_res = 0.05, layer_thickness = 0.5, plot = FALSE)
  expect_true(result$ENL0 == floor(result$ENL0))
})

test_that("enl ENL1 >= 1", {
  sphere <- gen_sphere(1, 0.01)
  result <- enl(sphere, voxel_res = 0.05, layer_thickness = 0.5, plot = FALSE)
  expect_true(result$ENL1 >= 1)
})

test_that("enl rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(enl(mat, voxel_res = 0.1, plot = FALSE), "pt_cld")
})

test_that("enl rejects invalid parameters", {
  sphere <- gen_sphere(1, 0.01)
  expect_error(enl(sphere, voxel_res = -1, plot = FALSE))
  expect_error(enl(sphere, voxel_res = 0.05, layer_thickness = -1, plot = FALSE))
})
