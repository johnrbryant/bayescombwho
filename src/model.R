
library(demest)

set.seed(0)

count_obese <- readRDS("out/count_obese.rds")
count_all <- readRDS("out/count_all.rds")

half_norm_main <- HalfT(df = Inf, scale = 1)
half_norm_inter <- HalfT(df = Inf, scale = 0.5)

model <- Model(y ~ Binomial(mean ~ country * sex + year),
               country ~ Exch(error = Error(scale = half_norm_main)),
               sex ~ ExchFixed(),
               year ~ DLM(level = Level(scale = half_norm_main),
                          trend = Trend(scale = half_norm_main),
                          damp = Damp(),
                          error = Error(scale = half_norm_main)),
               country:sex ~ Exch(error = Error(scale = half_norm_inter)),
               jump = 0.22)

filename <- "out/model.est"
estimateModel(model = model,
              y = count_obese,
              exposure = count_all,
              filename = filename,
              nBurnin = 20000,
              nSim = 20000,
              nThin = 80,
              nChain = 4)

options(width = 120)
fetchSummary(filename, nSample = 100)

