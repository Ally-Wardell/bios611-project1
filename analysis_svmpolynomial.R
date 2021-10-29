# Program Name: analysis_svm_linear.R
# Purpose: Machine learning SVM model with a polynomial kernel

library('tidyverse')
library('flextable')
library('webshot')

derived_heart <- read_csv("~/bios611/derived_data/derived_heart.csv") %>%
  mutate(Target=factor(Target))


set.seed(12)
tt_indices <- createFolds(y=derived_heart$Target, k=5)
error_per_fold <- list()
error_per_fold_regress <- list()
for(i in 1:5){
  train_data <- derived_heart[-tt_indices[[i]],]
  test_data <- derived_heart[tt_indices[[i]],]
  
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
  
  # Create linear regression model
  lm_fit <- glm(Target~., data=train_data, family=binomial)
  test_data$predict_lm <- factor(ifelse(predict(lm_fit, newdata=test_data,
                                                type="response")>0.5,1,0))
  
  # Store MSE
  error_per_fold[[i]] <- confusionMatrix(data = test_data$predict_svm,
                                         reference = test_data$Target)$byClass
  error_per_fold_regress[[i]] <- confusionMatrix(data = test_data$predict_lm,
                                                 reference = test_data$Target)$byClass
}
# Bind together, add MSE
error_all_folds <- do.call("rbind", error_per_fold)
error_all_folds_regress <- do.call("rbind", error_per_fold_regress)
# mse_all_folds_regress <- cbind(mse_all_folds_regress, 
#                                "MSE"=(mse_all_folds_regress[,"RMSE"])^2)


# Get mean and SE MSE
svm_cv_results <- 
  data.frame("Method"="svm",
             "CV_Accuracy"=apply(error_all_folds[,c("Sensitivity", "Specificity")], 
                                 MARGIN = 2, FUN = mean),
             "CV_Accuracy_SE"=apply(error_all_folds[,c("Sensitivity", 
                                                       "Specificity")], 
                                    MARGIN = 2, FUN = sd))
#%>%
# rownames_to_column(var="Measure")

# Do same for regression
regress_cv_results <- 
  data.frame("Method"="lm",
             "CV_Accuracy"=
               apply(error_all_folds_regress[,c("Sensitivity", "Specificity")], 
                     MARGIN = 2, FUN = mean),
             "CV_Accuracy_SE"=apply(error_all_folds_regress[,c("Sensitivity", 
                                                               "Specificity")], 
                                    MARGIN = 2, FUN = sd))
#%>% rownames_to_column(var="Measure")

# Print results in flextable (not needed, but useful)
all_results <- rbind(svm_cv_results, regress_cv_results)

table2_svmpoly <- flextable(all_results)

save_as_image(table2_svmpoly, path = "/home/rstudio/bios611/table2_svmpoly.png")
