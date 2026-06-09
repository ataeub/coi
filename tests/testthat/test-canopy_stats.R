test_that("canopy_stats returns expected list elements", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_type(result, "list")
  expect_true(all(c("max", "mean", "sd", "cv", "gini", "openness", "grid") %in% names(result)))
})

test_that("canopy_stats max >= mean", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_true(result$max >= result$mean)
})

test_that("canopy_stats with lower_cutoff filters heights", {
  sphere <- gen_sphere(1, 0.01)
  r1 <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  r2 <- canopy_stats(sphere, res = 0.1, lower_cutoff = 0.5, plot = FALSE)
  # With cutoff, mean should be higher (low values excluded)
  expect_true(r2$mean >= r1$mean)
})

test_that("canopy_stats applies lower_cutoff to openness and plotting", {
  cloud <- pt_cld(
    x = c(0, 1, 0, 1),
    y = c(0, 0, 1, 1),
    z = c(0, 5, 2, 6)
  )

  result <- canopy_stats(cloud, res = 1, lower_cutoff = 3, plot = TRUE)

  expect_equal(result$openness, 0.5)
  expect_equal(sum(!is.na(result$grid)), 2)
  expect_true(is.na(result$grid["0", "0"]))
  expect_true(is.na(result$grid["1", "0"]))
  expect_equal(nrow(result$plot$data), 2)
})

test_that("canopy_stats uses z values relative to the cloud minimum", {
  base <- pt_cld(
    x = c(0, 0, 1, 1),
    y = c(0, 0, 0, 0),
    z = c(0, 2, 1, 3)
  )
  shifted <- pt_cld(base[, "x"], base[, "y"], base[, "z"] + 10)

  base_stats <- canopy_stats(base, res = 1, lower_cutoff = 2.5, plot = FALSE)
  shifted_stats <- canopy_stats(shifted, res = 1, lower_cutoff = 2.5, plot = FALSE)

  expect_equal(shifted_stats, base_stats)
})

test_that("canopy_stats warns when all heights below cutoff", {
  sphere <- gen_sphere(1, 0.01)
  expect_warning(
    canopy_stats(sphere, res = 0.1, lower_cutoff = 100, plot = FALSE),
    "No canopy heights"
  )
})

test_that("canopy_stats rejects invalid res", {
  sphere <- gen_sphere(1, 0.01)
  expect_error(canopy_stats(sphere, res = -1, plot = FALSE), "res must be")
  expect_error(canopy_stats(sphere, res = "a", plot = FALSE), "res must be")
})

test_that("canopy_stats rejects non-pt_cld", {
  mat <- matrix(runif(30), ncol = 3)
  expect_error(canopy_stats(mat, res = 0.1, plot = FALSE), "pt_cld")
})

test_that("canopy_stats grid is a matrix", {
  sphere <- gen_sphere(1, 0.01)
  result <- canopy_stats(sphere, res = 0.1, plot = FALSE)
  expect_true(is.matrix(result$grid))
})

test_that("canopy_stats treats radius as an explicit circular footprint", {
  sphere <- gen_sphere(1, 0.1)

  implicit <- canopy_stats(sphere, res = 0.1, radius = 1, plot = FALSE)
  explicit <- canopy_stats(
    sphere,
    res = 0.1,
    footprint = "circ",
    radius = 1,
    plot = FALSE
  )

  expect_equal(implicit$openness, explicit$openness)
})

test_that("canopy_stats validates circular footprint arguments", {
  sphere <- gen_sphere(1, 0.1)

  expect_error(
    canopy_stats(sphere, res = 0.1, radius = -1, plot = FALSE),
    "radius must be"
  )
  expect_error(
    canopy_stats(sphere, res = 0.1, footprint = "circ", plot = FALSE),
    "radius must be supplied"
  )
  expect_error(
    canopy_stats(
      sphere,
      res = 0.1,
      footprint = "rect",
      radius = 1,
      plot = FALSE
    ),
    "radius can only be used"
  )
})
