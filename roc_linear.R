# Program Name: roc_linear.R
# Purpose: Machine learning linear model : ROC CURVE

library(tidyverse)
library(caret)
library(pROC)
library(e1071)

derived_heart <- read_csv("derived_data/derived_heart.csv") %>%
  mutate(Target=factor(Target))

set.seed(12)
derived_heart_tt_index <- createDataPartition(derived_heart$Target,
                                              p=0.6, list = FALSE)
train_data <- derived_heart[derived_heart_tt_index,]
test_data <- derived_heart[-derived_heart_tt_index,]



# Create linear regression model
lm_fit <- glm(Target~., data=train_data, family=binomial)
test_data$predict_lm <- factor(ifelse(predict(lm_fit, newdata=test_data,
                                              type="response")>0.5,1,0))
test_data = test_data %>% 
  mutate(predict_lm = as.numeric(predict_lm))

roc_obj_lm <- 
  roc(response = test_data$Target, 
      predictor = test_data$predict_lm)

best_thres_data <- 
  data.frame(coords(roc_obj_lm, x="best", best.method = c("youden")))

# Plot ROC curve
lm_roc_plot = ggroc(roc_obj_lm)+
  geom_point(
    data = best_thres_data,
    mapping = aes(x=specificity, y=sensitivity), size=2, color="red")+
  geom_point(mapping=aes(x=best_thres_data$specificity, 
                         y=1-best_thres_data$specificity), 
             size=2, color="red")+
  geom_segment(aes(x = 1, xend = 0, y = 0, yend = 1),
               color="darkgrey", linetype="dashed")+
  geom_text(data = best_thres_data,
            mapping=aes(x=specificity, y=1.05,
                        label=paste0("Sensitivity = ", round(sensitivity,2),
                                     "\nSpecificity = ", round(specificity,2))))+
  labs(title = 
         paste0("ROC curve for predicting heart disease using linear model, on test set\nAUC = ", round(auc(roc_obj_lm),2)))+
  theme_classic()


png("figures/roc_linear.png")
plot(lm_roc_plot)
dev.off()