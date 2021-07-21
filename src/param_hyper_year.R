
library(demest)
library(dplyr)
library(readr)

## Functions to calculation method-of-moments estimates

sd_half_norm <- function(y) {
    n <- length(y)
    ss <- sum(y^2)
    sqrt(ss / n)
}

param_beta <- function(y, min = 0.8, max = 1) {
    y_trans <- (y - min) / (max - min)
    m <- mean(y_trans)
    v <- var(y_trans)
    stopifnot(v < m * (1 - m))
    shape1 <- m * (m * (1 - m) / v - 1)
    shape2 <- (1 - m) * shape1
    c(shape1 = shape1,
      shape2 = shape2)
}


## Parameter values

scale_level <- fetch("out/model.est",
                     where = c("model", "hyper", "year", "scaleLevel")) %>%
    as.numeric()

scale_trend <- fetch("out/model.est",
                     where = c("model", "hyper", "year", "scaleTrend")) %>%
    as.numeric()

scale_error <- fetch("out/model.est",
                     where = c("model", "hyper", "year", "scaleError")) %>%
    as.numeric()

damp <- fetch("out/model.est",
              where = c("model", "hyper", "year", "damp"))  %>%
    as.numeric()


## Parameter estimates for hyper-parameters for year effect

param_hyper_year <- data.frame(parameter = c("level",
                                             "trend",
                                             "error",
                                             "shape1",
                                             "shape2"),
                               value = c(sd_half_norm(scale_level),
                                         sd_half_norm(scale_trend),
                                         sd_half_norm(scale_error),
                                         param_beta(damp)))

write_csv(param_hyper_year,
          path = "out/param_hyper_year.csv")
