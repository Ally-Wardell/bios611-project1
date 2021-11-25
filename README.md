# README
## What does this project contain? 
This repository contains the data, code, and results of an analysis of 
Cardiovascular disease data. Cardiovascular disease is the leading cause 
of death in the United States. Most cardiovascular diseases can be prevented by addressing 
behavioral risk factors. A predictive model for heart disease development could be useful in
sparking heart disease treatment and prevention plans for early development of heart disease.

I include an Rshiny app to do visualize the continuous predictors across each category of heart
disease presence (0 = no heart disease, 1 = low evidence of heart disease, ... 4 = strong evidence 
of heart disease)

## What is the source data? 

This analysis is based on research from Robert Detrano and colleagues, who wrote
a paper titled "International application of a new probability algorithm for the diagnosis of coronary 
artery disease." (1989). This data set contains information on 301 individuals. 
Examples of measured risk factors of cardiovascular disease are age, sex, resting ECG, cholestrol, etc. 


If you wish to replicate this exact analysis, use the CSVs in the source_data folder of this respository.

# How do I build the docker image? 

Run the follwoing commands to set up a docker image. Note that you should insert your own unique 
password and change the path in the command to the project folder in your personal directory. 

Command to build docker image: 

`docker build . -t bios611_project`

Command to run docker image (RStudio): 

`docker run -v <insert path to project folder>:/home/rstudio/bios611 -e PASSWORD=<insert unique password> --rm -p 8080:8080 -p 8787:8787 -t bios611_project`

Example: 

`docker run -v /Users/allywardell/bios611/home/rstudio/bios611 -e PASSWORD=canyon --rm -p 8080:8080 -p 8787:8787 -t bios611_project`

After that use localhost:8787 to open up rstudio in your web browser. Set bios611 as the present
working directory. Use the gear icon. 

# How do I construct the project write-up? 

In the Rstudio terminal type:  `make project1_writeup.pdf`

# How do I construct the Rshiny app? 

To construct the Rshiny app, use the `docker run ...` instructions above, then, 
type `make shiny_app`, then navigate to localhost:8080 in your web browser. 

