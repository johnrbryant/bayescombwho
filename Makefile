
.PHONY: all
all: out/param_hyper_year.csv


out/data_df.rds: src/data_df.R \
                 data/xmart.csv
	Rscript $<

out/count_obese.rds: src/count.R \
                     out/data_df.rds
	Rscript $< --variant=obese

out/count_all.rds: src/count.R \
                   out/data_df.rds
	Rscript $< --variant=all

out/model.est: src/model.R \
               out/count_obese.rds \
               out/count_all.rds
	Rscript $<

out/param_hyper_year.csv: src/param_hyper_year.R \
                          out/model.est
	Rscript $<


.PHONY: clean
clean:
	rm -rf out
	mkdir out
