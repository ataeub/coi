# ---- Constructor: pt_cld() ----

test_that("pt_cld() creates from vectors", {
  cloud <- pt_cld(1:5, 6:10, 11:15)
  expect_s3_class(cloud, "pt_cld")
  expect_equal(ncol(cloud), 3)
  expect_equal(nrow(cloud), 5)
  expect_equal(colnames(cloud), c("x", "y", "z"))
  expect_equal(storage.mode(cloud), "double")
})

test_that("pt_cld() creates from matrix", {
  mat <- matrix(runif(30), ncol = 3)
  cloud <- pt_cld(mat)
  expect_s3_class(cloud, "pt_cld")
  expect_equal(nrow(cloud), 10)
  expect_equal(colnames(cloud), c("x", "y", "z"))
})

test_that("pt_cld() creates from data.frame", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  cloud <- pt_cld(df)
  expect_s3_class(cloud, "pt_cld")
  expect_equal(nrow(cloud), 5)
})

test_that("pt_cld() keeps only first 3 columns", {
  mat <- matrix(runif(40), ncol = 4)
  cloud <- pt_cld(mat)
  expect_equal(ncol(cloud), 3)
})

test_that("pt_cld() rejects NAs", {
  mat <- matrix(c(1, 2, NA, 4, 5, 6), ncol = 3)
  expect_error(pt_cld(mat), "NAs")
})

test_that("pt_cld() rejects too few columns", {
  mat <- matrix(1:6, ncol = 2)
  expect_error(pt_cld(mat), "at least 3 columns")
})

test_that("pt_cld() rejects non-numeric vectors", {
  expect_error(pt_cld("a", "b", "c"), "numeric")
})

test_that("pt_cld() rejects unequal length vectors", {
  expect_error(pt_cld(1:3, 1:4, 1:3), "same length")
})

test_that("pt_cld() rejects partial y/z", {
  expect_error(pt_cld(1:3, y = 1:3), "all three")
})

# ---- Coercion: as_pt_cld() ----

test_that("as_pt_cld() converts data.frame", {
  df <- data.frame(x = 1:5, y = 6:10, z = 11:15)
  cloud <- as_pt_cld(df)
  expect_s3_class(cloud, "pt_cld")
})

test_that("as_pt_cld() converts matrix", {
  mat <- matrix(runif(15), ncol = 3)
  cloud <- as_pt_cld(mat)
  expect_s3_class(cloud, "pt_cld")
})

test_that("as_pt_cld() is no-op on pt_cld", {
  cloud <- pt_cld(1:5, 6:10, 11:15)
  cloud2 <- as_pt_cld(cloud)
  expect_identical(cloud, cloud2)
})

test_that("as_pt_cld() rejects unsupported types", {
  expect_error(as_pt_cld("string"), "Cannot convert")
  expect_error(as_pt_cld(42), "Cannot convert")
})

# ---- Validator: is_pt_cld() ----

test_that("is_pt_cld() returns TRUE for pt_cld objects", {
  cloud <- pt_cld(1:3, 4:6, 7:9)
  expect_true(is_pt_cld(cloud))
})

test_that("is_pt_cld() returns FALSE for other types", {
  expect_false(is_pt_cld(matrix(1:9, ncol = 3)))
  expect_false(is_pt_cld(data.frame(x = 1)))
  expect_false(is_pt_cld(42))
})

# ---- .validate_pt_cld() ----

test_that(".validate_pt_cld() passes for pt_cld", {
  cloud <- pt_cld(1:3, 4:6, 7:9)
  expect_silent(coi:::.validate_pt_cld(cloud))
})

test_that(".validate_pt_cld() errors for non-pt_cld", {
  mat <- matrix(1:9, ncol = 3)
  expect_error(coi:::.validate_pt_cld(mat), "must be a pt_cld object")
})

test_that(".validate_pt_cld() uses custom arg name in error", {
  mat <- matrix(1:9, ncol = 3)
  expect_error(coi:::.validate_pt_cld(mat, "my_arg"), "'my_arg'")
})

# ---- S3 methods ----

test_that("print.pt_cld prints summary", {
  cloud <- pt_cld(c(0, 1), c(0, 1), c(0, 1))
  out <- capture.output(print(cloud))
  expect_match(out[1], "pt_cld with 2 points")
  expect_match(out[2], "x:")
})

test_that("print.pt_cld returns invisibly", {
  cloud <- pt_cld(1:3, 4:6, 7:9)
  expect_invisible(print(cloud))
})

test_that("summary.pt_cld shows statistics", {
  cloud <- pt_cld(c(0, 10), c(0, 10), c(0, 10))
  out <- capture.output(summary(cloud))
  expect_match(out[1], "pt_cld with 2 points")
})

test_that("$ accessor works for x, y, z", {
  cloud <- pt_cld(1:5, 6:10, 11:15)
  expect_equal(cloud$x, c(1, 2, 3, 4, 5))
  expect_equal(cloud$y, c(6, 7, 8, 9, 10))
  expect_equal(cloud$z, c(11, 12, 13, 14, 15))
})

test_that("$ accessor rejects invalid names", {
  cloud <- pt_cld(1:5, 6:10, 11:15)
  expect_error(cloud$foo, "only have")
})

test_that("[.pt_cld row subset preserves class", {
  cloud <- pt_cld(1:10, 11:20, 21:30)
  sub <- cloud[1:5, ]
  expect_s3_class(sub, "pt_cld")
  expect_equal(nrow(sub), 5)
})

test_that("[.pt_cld column subset drops class", {
  cloud <- pt_cld(1:10, 11:20, 21:30)
  xy <- cloud[, 1:2]
  expect_false(inherits(xy, "pt_cld"))
})

test_that("[.pt_cld single column returns vector", {
  cloud <- pt_cld(1:5, 6:10, 11:15)
  z <- cloud[, "z"]
  expect_true(is.numeric(z))
  expect_equal(length(z), 5)
})

test_that("rbind.pt_cld combines clouds", {
  c1 <- pt_cld(1:3, 4:6, 7:9)
  c2 <- pt_cld(10:12, 13:15, 16:18)
  combined <- rbind(c1, c2)
  expect_s3_class(combined, "pt_cld")
  expect_equal(nrow(combined), 6)
})
