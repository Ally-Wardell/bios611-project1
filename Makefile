.PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*
	rm -f project1_writeup.pdf

project1_writeup.pdf: project1_writeup.Rmd derived_data/derived_heart.csv\
 derived_data/shiny_heart.csv figures/table1_descriptive.png\
 figures/table2_svmlinear.png figures/table2_svmpoly.png\
 figures/roc_svm_poly.png figures/roc_svm_linear.png\
 figures/roc_rf.png figures/roc_linear.png
	R -e "rmarkdown::render('project1_writeup.Rmd',output_format='pdf_document')"

derived_data/derived_heart.csv: source_data/heart_data.csv derived_heart.R
	Rscript derived_heart.R

derived_data/shiny_heart.csv: source_data/heart_data.csv shiny_heart.R
	Rscript shiny_heart.R

figures/table1_descriptive.png: derived_data/derived_heart.csv table1_descriptive.R
	Rscript table1_descriptive.R

figures/table2_svmlinear.png: derived_data/derived_heart.csv analysis_svm_linear.R
	Rscript analysis_svm_linear.R

figures/table2_svmpoly.png: derived_data/derived_heart.csv analysis_svmpolynomial.R
	 Rscript analysis_svmpolynomial.R

figures/table2_randomforest.png: derived_data/derived_heart.csv analysis_rf.R
	Rscript analysis_rf.R

figures/roc_linear.png: derived_data/derived_heart.csv roc_linear.R
	Rscript roc_linear.R
	 
figures/roc_rf.png: derived_data/derived_heart.csv roc_rf.R
	Rscript roc_rf.R

figures/roc_svm_linear.png: derived_data/derived_heart.csv roc_svm_linear.R
	Rscript roc_svm_linear.R

figures/roc_svm_poly.png: derived_data/derived_heart.csv roc_svm_poly.R
	Rscript roc_svm_poly.R

# PHONY: shiny_app
# Make target for Rshiny app of interactive plots
shiny_app: derived_data/shiny_heart.csv shiny_app/app.R
	Rscript shiny_app/app.R 
