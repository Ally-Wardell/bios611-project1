# Program Name: preliminary_plots.R
# Purpose: Exploratory preliminary plots

library(tidyverse)
library(patchwork)
library(webshot)

shiny_heart = read.csv("derived_data/shiny_heart.csv")

shiny_order <- shiny_heart %>% mutate(target_ordered = Target_str %>% fct_infreq() %>% fct_rev())

p = ggplot(shiny_order, aes(y=target_ordered))
p = p + geom_bar()
p


#Age vs. other continuous covariates

p2 = ggplot(shiny_heart, aes(x = Resting_Blood_Pressure,
                             y = Age))
p2 = p2 + geom_point() + geom_smooth(method='lm')
p2 = p2 + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
p2 = p2 + xlab("Resting BP")
#p2

p3 = ggplot(shiny_heart, aes(x = MAX_Heart_Rate,
                             y = Age))
p3 = p3 + geom_point() + geom_smooth(method='lm')
p3 = p3 + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
p3 = p3 + xlab("Maximum HR")
#p3

p4 = ggplot(shiny_heart, aes(x = Colestrol,
                             y = Age))
p4 = p4 + geom_point() + geom_smooth(method='lm')
p4 = p4 + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
p4 = p4 + xlab("Cholesterol")
#p4

patchwork <- p2 + p3 + p4
patchwork = patchwork + plot_annotation(
  title = 'Age vs. Other Covariates',
  subtitle = 'These plots will provide information for positive or negative
              correlations between age and continuous covariates'
)

patchwork

save_as_image(patchwork, path = "figures/continuous_descr_plots.png")
