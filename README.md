# README
## What does this project contain? 
This repository contains the data, code, and results of an analysis of 
Cardiovascular disease data. Cardiovascular disease the leading cause 
of death in the United States. Most cardiovascular diseases can be prevented by addressing 
behavioral risk factors such as tobacco use, poor diet, obesity, alcohol consumption, 
and physical activity. People with a high risk of cardiovascular disease could benefit from
the use of predictive modeling techniques for early detection of disease. 

I include an Rshiny app to do X, Y, Z. 

## What is the source data? 

This analysis is based on research from Davide Chicco and Giuseppe Jurman who wrote
a paper titled "Machine learning can predict survival of patients with heart failure from serum 
creatinine and ejection fraction alone" (2020). This data set contains information on 299 individuals. 
Examples of measured risk factors of cardiovascular disease are age, anaemia, level of creatinine phosphorous in the blood, diabetes, ejection fraction (%), high blood pressure, platelets, serum
creatinine, and serum sodium levels. 

If you wish to replicate this exact analysis, use the CSVs in the source_data folder of this respository.

# How do I build the docker image? 

Run the follwoing commands to set up a docker image. Note that you should insert your own unique 
password and change the path in the command to the project folder in your personal directory. 

Command to build docker image: 

`docker build . -t bios611_project`

Command to run docker image (RStudio): 

`docker run -v <insert path to project folder>:/home/rstudio/project -e -PASSWORD=<insert unique password> --rm -p 8787:8787 bios611_project`

Example: 

`docker run -v <insert path to project folder>:/home/rstudio/project -e -PASSWORD=<insert unique password> --rm -p 8787:8787 bios611_project`

# How do I construct the project write-up? 

# How do I construct the Rshiny app? 


