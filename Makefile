PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*
	rm -f project1_writeup.pdf

project1_writeup.pdf: project1_writeup.Rmd derived_data/derived_heart.csv\
 derived_data/shiny_heart.csv table1_descriptive.png\
 table2_svmlinear.png table2_svmpoly.png
	R -e "rmarkdown::render('project1_writeup.Rmd',output_format='pdf_document')"

derived_data/derived_heart.csv: source_data/heart_data.csv derived_heart.R
	Rscript derived_heart.R

derived_data/shiny_heart.csv: source_data/heart_data.csv shiny_heart.R
	Rscript shiny_heart.R

table1_descriptive.png: derived_data/derived_heart.csv table1_descriptive.R
	Rscript table1_descriptive.R

table2_svmlinear.png: derived_data/derived_heart.csv analysis_svm_linear.R
	Rscript analysis_svm_linear.R

table2_svmpoly.png: derived_data/derived_heart.csv analysis_svmpolynomial.R
	 Rscript analysis_svmpolynomial.R



# PHONY: shiny_app
# Make target for Rshiny app of interactive plots
shiny_app: derived_data/shiny_heart.csv shiny_app/app.R
	Rscript shiny_app/app.R 
