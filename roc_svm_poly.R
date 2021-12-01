# Program Name: roc_svm_poly.R
# Purpose: Machine learning SVM model with a polynomial kernel : ROC CURVE

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

# Tune SVM
tune_svm <- 
  tune(svm, Target~., data=train_data, kernel ="polynomial",
       ranges = list(gamma = 0.035, 
                     cost = 1:5,
                     epsilon = seq(from=0.1, to=0.5, by=0.1)))

# Get best model
svm_tuned <- tune_svm$best.model
test_data$predict_svm <- predict(svm_tuned, newdata=test_data,
                                 type="response")

test_data = test_data %>% 
  mutate(predict_svm = as.numeric(predict_svm))

roc_obj_svmp <- 
  roc(response = test_data$Target, 
      predictor = test_data$predict_svm)

best_thres_data <- 
  data.frame(coords(roc_obj_svmp, x="best", best.method = c("youden")))

# Plot ROC curve
svmp_roc_plot = ggroc(roc_obj_svmp)+
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
         paste0("ROC curve for predicting heart disease using SVM Polynomial Kernel, on test set\nAUC = ", round(auc(roc_obj_svmp),2)))+
  theme_classic()


png("figures/roc_svm_poly.png")
plot(svmp_roc_plot)
dev.off()
