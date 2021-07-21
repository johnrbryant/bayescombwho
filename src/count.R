
library(dembase)
library(dplyr)
library(docopt)
'
Usage:
count.R [options]
Options:
--variant (obese|all) [default: obese]
' -> doc
opts <- docopt(doc)
variant <- opts$variant

count <- readRDS("out/data_df.rds") %>%
    filter(tolower(variant) == !!variant) %>%
    dtabs(count ~ country + sex + year) %>%
    Counts(dimscales = c(year = "Points"))

file <- sprintf("out/count_%s.rds", variant)
saveRDS(count,
        file = file)
    
