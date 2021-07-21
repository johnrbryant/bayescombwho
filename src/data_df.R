
library(readr)
library(dplyr)
library(tidyr)


year <- readLines("data/xmart.csv", n = 1L) %>%
    strsplit(split = ",") %>%
    unlist() %>%
    gsub("\"", "", .)

sex <- readLines("data/xmart.csv", n = 4L)[[4L]] %>%
    strsplit(split = ",") %>%
    unlist() %>%
    gsub("\"| ", "", .)


p_value <- "^([0-9.]+) \\[([0-9.]+)-([0-9.]+)\\]$"
data_df <- read_csv("data/xmart.csv",
                      skip = 4,
                      col_names = FALSE) %>%
    setNames(paste(year, sex)) %>%
    rename(country = " Country") %>%
    gather(key = year_sex, value = value, -country) %>%
    separate(col = year_sex, into = c("year", "sex")) %>%
    filter(sex != "Bothsexes") %>%
    mutate(year = as.integer(year)) %>%
    filter(year >= 1990) %>%
    mutate(mid = sub(p_value, "\\1", value),
           low = sub(p_value, "\\2", value),
           high = sub(p_value, "\\3", value),
           mid = as.numeric(mid) / 100,
           low = as.numeric(low) / 100,
           high = as.numeric(high) / 100) %>%
    mutate(n_init = (mid - mid^2) / ((high - low)^2 / 16)) %>%
    group_by(country) %>%
    mutate(n = median(n_init, na.rm = TRUE)) %>%
    ungroup() %>%
    mutate(y = mid * n) %>%
    mutate(n_obese = as.integer(y),
           n_sampled = as.integer(n)) %>%
    filter(!is.na(n_obese)) %>%
    select(country, year, sex, Obese = n_obese, All = n_sampled) %>%
    gather(key = variant, value = count, Obese, All)

saveRDS(data_df,
        file = "out/data_df.rds")


