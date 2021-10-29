# Program Name: shiny_heart.R
# Purpose: This program keeps all 4 targets to use in the shiny app
#          and names the categories

library('tidyverse')

heart_data <- read_csv("~/bios611/source_data/heart_data.csv",  na=c("", "NA", "?"))


shiny_heart <- heart_data %>%
  mutate(Target_str = factor(ifelse(Target == 0, "No Heart Disease", 
                             ifelse(Target==1, "Little evidence of heart disease", 
                             ifelse(Target==2, "Mild evidence of heart disease", 
                             ifelse(Target==3, "Moderate evidence of heart disease", 
                                    "High evidence of heart disease")))))) %>%
  drop_na()

write_csv(shiny_heart, "~/bios611/derived_data/shiny_heart.csv" )



