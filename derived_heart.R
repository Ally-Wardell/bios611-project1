# Program Name: derived_heart.R
# Purpose: This program cleans data and dichotomizes target (the outcome)

library('tidyverse')

heart_data <- read_csv("~/bios611/source_data/heart_data.csv",  na=c("", "NA", "?"))

derived_heart <- heart_data %>%
  mutate(Target=factor(ifelse(Target>1, 1, Target))) %>%
  #select(-`...1`) %>%
  drop_na()

write_csv(derived_heart, "~/bios611/derived_data/derived_heart.csv" )

