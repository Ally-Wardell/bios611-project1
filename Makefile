table_descriptive1.png: source_data/heart_data.csv data_summary.Rmd
	Rscript data_summary.Rmd


# .PHONY: shiny_app
# Make target for Rshiny app of interactive histogram
shiny_app: derived_data/derived_heart.csv shiny_app/app/app.R
	Rscript shiny_app/app/app.R ${PORT}
