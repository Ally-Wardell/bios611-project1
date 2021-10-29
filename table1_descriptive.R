# Program Name: table1_descriptive.R
# Purpose:This program provides descriptive stats for each covariate 
#         by dichotomized heart disease status

library('tidyverse')
library('webshot')
library('flextable')
library('gtsummary')

derived_heart = read_csv("~/bios611/derived_data/derived_heart.csv")

table_descriptive1 <- tbl_summary(data= derived_heart,
                                  by=Target,
                                  statistic= all_continuous() ~ "{mean} ({sd})",
                                  label = list(Age ~ "Age",
                                               Sex ~ "Sex (M/F)",
                                               Chest_Pain ~ "Chest Pain",
                                               Resting_Blood_Pressure ~ "Resting Blood Pressure",
                                               Colestrol ~ "Cholesterol",
                                               Fasting_Blood_Sugar ~ "Fasting Blood Sugar",
                                               Rest_ECG ~ "Resting ECG",
                                               MAX_Heart_Rate ~ "Maximum Heart Rate",
                                               Exercised_Induced_Angina ~ "Exercise Induced Angina",
                                               ST_Depression ~ "Depression",
                                               Slope ~ "Slope",
                                               Major_Vessels ~ "Major Vessels",
                                               Thalessemia ~ "Thalessemia"),
                                  
                                  missing='no')%>%
  add_n() %>%
  add_p(test = list(all_continuous() ~ "aov",
                    all_categorical() ~ "chisq.test")) %>%
  as_flex_table() %>%
  bold( bold = TRUE, part = "header") %>%
  add_header_lines(values="Summary Statistics for Heart Failure Covariates")
table_descriptive1

save_as_image(table_descriptive1, path = "/home/rstudio/bios611/table1_descriptive.png")

