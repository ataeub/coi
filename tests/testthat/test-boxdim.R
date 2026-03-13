test_that("boxdim returns numeric scalar", {
  sphere <- gen_sphere(1, 0.01)
  result <- boxdim(sphere, threshold = 0.1, vox_res = 0.05)
  expect_true(is.numeric(result))
  expect_length(result, 1)
})

test_that("boxdim of larger sphere >= smaller sphere", {
  s_small <- gen_sphere(0.5, 0.05)
  s_large <- gen_sphere(1, 0.05)
  bd_small <- boxdim(s_small, 0.1, vox_res = NULL, warnings = FALSE)
  bd_large <- boxdim(s_large, 0.1, vox_res = NULL, warnings = FALSE)
  expect_true(bd_large >= bd_small)
})

test_that("boxdim warns when vox_res is NULL", {
  sphere <- gen_sphere(1, 0.1)
  expect_warning(
    boxdim(sphere, 0.1, vox_res = NULL, warnings = TRUE),
    "vox_res left undefined"
  )
})

test_that("boxdim suppresses warning when warnings = FALSE", {
  sphere <- gen_sphere(1, 0.1)
  expect_silent(boxdim(sphere, 0.1, vox_res = NULL, warnings = FALSE))
})

test_that("boxdim rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(boxdim(mat, 0.1), "must be a pt_cld object")
})
