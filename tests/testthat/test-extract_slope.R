test_that("extract_slope returns slope", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  # Flat plane at z = 0
  grid <- expand.grid(x = 1:10, y = 1:10)
  grid$z <- 0
  cloud <- as_pt_cld(grid)
  dtm <- extract_dtm(cloud, res = 2)
  result <- extract_slope(dtm)
  expect_type(result, "list")
  expect_true("slope" %in% names(result))
  expect_true(result$slope < 1) # nearly flat
})

test_that("extract_slope detects tilted plane", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  grid <- expand.grid(x = 1:20, y = 1:20)
  grid$z <- grid$x # 45-degree tilt along x
  cloud <- as_pt_cld(grid)
  dtm <- extract_dtm(cloud, res = 2)
  result <- extract_slope(dtm)
  expect_true(result$slope > 30)
})

test_that("extract_slope returns aspect when requested", {
  skip_if_not_installed("geometry")
  skip_if_not_installed("rgl")
  grid <- expand.grid(x = 1:10, y = 1:10)
  grid$z <- grid$x
  cloud <- as_pt_cld(grid)
  dtm <- extract_dtm(cloud, res = 2)
  result <- extract_slope(dtm, aspect = TRUE)
  expect_true("aspect" %in% names(result))
  expect_true(result$aspect >= 0 && result$aspect <= 360)
})

test_that("extract_slope rejects non-mesh3d", {
  expect_error(extract_slope("not_a_mesh"), "mesh3d")
})
