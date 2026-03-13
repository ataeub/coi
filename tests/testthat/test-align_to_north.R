test_that("align_to_north returns pt_cld", {
  cloud <- gen_sphere(1, 0.1)
  result <- align_to_north(cloud, p2 = c(1, 1))
  expect_true(is_pt_cld(result))
  expect_equal(nrow(result), nrow(cloud))
})

test_that("align_to_north preserves point count", {
  cloud <- gen_sphere(1, 0.1)
  result <- align_to_north(cloud, p2 = c(1, 0), heading = "north")
  expect_equal(nrow(result), nrow(cloud))
})

test_that("align_to_north accepts numeric heading", {
  cloud <- gen_sphere(1, 0.1)
  result <- align_to_north(cloud, p2 = c(1, 1), heading = 45)
  expect_true(is_pt_cld(result))
})

test_that("align_to_north accepts cardinal headings", {
  cloud <- gen_sphere(1, 0.1)
  for (h in c("north", "south", "east", "west", "n", "s", "e", "w")) {
    result <- align_to_north(cloud, p2 = c(1, 1), heading = h)
    expect_true(is_pt_cld(result))
  }
})

test_that("align_to_north preserves z values", {
  cloud <- gen_sphere(1, 0.1)
  result <- align_to_north(cloud, p2 = c(1, 1))
  expect_equal(result[, "z"], cloud[, "z"])
})

test_that("align_to_north rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(align_to_north(mat, p2 = c(1, 1)), "pt_cld")
})
