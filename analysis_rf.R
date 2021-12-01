# Program Name: analysis_rf.R
# Purpose: Machine learning random forest model

library('tidyverse')
library('randomForest')
library('flextable')
library('webshot')
library('caret')
library('e1071')

derived_heart <- read_csv("~/bios611/derived_data/derived_heart.csv") %>%
  mutate(Target=factor(Target))

total_p <- dim(derived_heart)[2]-1
tuning_grid <- expand.grid("trees"=c(50, 250, 500),
                           "p"=c(total_p/2, sqrt(total_p), total_p))
test_results <- list()
fold_k <- 5
tt_indices <- createFolds(y = derived_heart$Target, k=fold_k)
# Train, tune, test
for(i in 1:length(tt_indices)){
  
  # Create train, test sets
  heart_train <-derived_heart[-tt_indices[[i]],]
  heart_test <-derived_heart[tt_indices[[i]],]
  
  # Tune over grid
  tune_results <- c()
  for(j in 1:dim(tuning_grid)[1]){
    set.seed(12)
    rf_tune <- randomForest(Target~., data=heart_train,
                            mtry = tuning_grid$p[j],
                            ntree = tuning_grid$trees[j])
    tune_results[j] <- rf_tune$err.rate[tuning_grid$trees[j], 1]
  }
  
  train_tune_results <- cbind(tuning_grid, "oob_error"=tune_results)
  best_tune <- train_tune_results[which(tune_results==min(tune_results)),][1,]
  
  # Fit on training use best tune
  set.seed(12)
  rf_fit <- randomForest(Target~., data=heart_train,
                         mtry = best_tune$p,
                         ntree = best_tune$trees)
  
  # Test on test data
  heart_test$test_predict <- predict(rf_fit, newdata=heart_test)
  
  # Save fold-specific, class-specific error rates
  per_class_accuracy <- rep(NA, length(levels(heart_test$Target)))
  
  for(l in 1:length(per_class_accuracy)){
    per_class_accuracy[l] <- 
      heart_test %>%
      filter(Target==levels(Target)[l]) %>%
      summarise(accuracy = sum(test_predict==levels(Target)[l])/n()) %>%
      unlist()
    
    names(per_class_accuracy)[l] <- 
      paste0("accuracy_", levels(heart_test$Target)[l])
  }
  
  test_results[[i]] <- per_class_accuracy
}
# Compute CV error estimates and CV SE of estimates
test_results_all_rf <- data.frame(do.call("rbind", test_results))
cv_error <- apply(test_results_all_rf, 2, mean)
cv_error_se <- apply(test_results_all_rf, 2, sd)
# Create data frame for flex table
all_results <- data.frame("Heart Disease Category"=levels(derived_heart$Target),
                          "CV sensitivity/specificity"=cv_error,
                          "CV sensitivity/specificity SE"=cv_error_se)
rownames(all_results) <- NULL
flextable(all_results)

table2_randomforest <- flextable(all_results) %>% 
  add_header_lines(values = "Random Forest Sensitivity/specificty")
 

save_as_image(table2_randomforest, path = "figures/table2_randomforest.png")
