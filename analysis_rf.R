# Program Name: analysis_rf.R
# Purpose: Machine learning random forest model

library('tidyverse')
library('randomForest')
library('flextable')
library('webshot')

derived_heart <- read_csv("~/bios611/derived_data/derived_heart.csv") %>%
  mutate(Target=factor(Target))

individualfolds<- createFolds(y=derived_heart$Target, k=5)
per_class_accuracy <- list()
for(i in 1:length(individualfolds)){
  heart_train <- derived_heart[-individualfolds[[i]],]
  heart_test <- derived_heart[individualfolds[[i]],]
  
  # Try different number of predictors at split
  reg_rf_preds_tune <- list() 
  reg_rf_oob_error <- list()
  tree_num <- c(50, 250, 500)
  # There are 29 predictors
  m_num <- c( (6/2), 6)
  
  counter <- 1
  for(h in 1:length(tree_num)){
    for(j in 1:length(m_num)){
      reg_rf_preds_tune[[counter]] <- randomForest(Target~., heart_train,
                                                   ntree=tree_num[h], mtry=m_num[j])
      reg_rf_oob_error[[counter]] <-
        data.frame("tree_size"=tree_num[h],
                   "num_pred" =m_num[j],
                   "oob_error"=reg_rf_preds_tune[[counter]]$err.rate[tree_num[h]])
      counter <- counter+1
    }
  }
  
  reg_rf_oob_error_df <- do.call("rbind", reg_rf_oob_error)
  reg_rf_oob_error_df
  
  # Refit on training using best no. of predictors at split
  best_error <- which(reg_rf_oob_error_df$oob_error==min(reg_rf_oob_error_df$oob_error))
  reg_rf <- randomForest(Target~., heart_train,
                         ntree=reg_rf_oob_error_df$tree_size[best_error], mtry=reg_rf_oob_error_df$num_pred[best_error])
  
  # Evaluate on test set
  heart_test$rf_predict <- predict(reg_rf, newdata = heart_test)
  
  #Per-class accuracies
  per_class_accuracy[[i]] <- rep(NA, length(levels(heart_test$Target)))
  for(l in 1:length(per_class_accuracy[[i]])){
    per_class_accuracy[[i]][l] <- 
      heart_test %>%
      filter(Target==levels(Target)[l]) %>%
      summarise(error = 1-sum(rf_predict==levels(Target)[l])/n()) %>%
      unlist()
    
    names(per_class_accuracy[[i]])[l] <- 
      paste0("error_", levels(heart_test$Target)[l])
  }
  
}
data_set_list  <- as.data.frame(t(do.call("rbind", per_class_accuracy) %>%
                                    apply(MARGIN=2, FUN=mean, na.rm=TRUE)))

data_set_list %>%
  flextable() %>% 
  colformat_num(digits=4) %>%
  add_header_lines(values="CV ERRORS PER CLASS")

data_set_list_se <- as.data.frame(t(do.call("rbind", per_class_accuracy) %>%
                                      apply(MARGIN=2, FUN=sd, na.rm=TRUE))) 

data_set_list_se %>%
  flextable() %>% 
  colformat_num(digits=4) %>%
  add_header_lines(values="CV ERROR SE PER CLASS")