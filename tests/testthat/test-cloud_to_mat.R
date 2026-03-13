test_that("cloud_to_mat is deprecated", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  expect_warning(cloud_to_mat(df), "deprecated")
})

test_that("cloud_to_mat returns pt_cld for xyz", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  suppressWarnings({
    result <- cloud_to_mat(df, "xyz")
  })
  expect_s3_class(result, "pt_cld")
})

test_that("cloud_to_mat returns subset columns", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  suppressWarnings({
    xy <- cloud_to_mat(df, "xy")
  })
  expect_equal(ncol(xy), 2)
  expect_false(inherits(xy, "pt_cld"))
})

test_that("cloud_to_mat rejects invalid which", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  suppressWarnings({
    expect_error(cloud_to_mat(df, "abc"), "combination of x, y, and z")
  })
})
