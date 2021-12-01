# Program Name: roc_rf.R
# Purpose: Machine learning random forest : ROC CURVE

library('tidyverse')
library('randomForest')
library('flextable')
library('pROC')
library('caret')
library('e1071')
library('webshot')

derived_heart <- read_csv("~/bios611/derived_data/derived_heart.csv") %>%
  mutate(Target=factor(Target))

total_p <- dim(derived_heart)[2]-1
tuning_grid <- expand.grid("trees"=c(50, 250, 500),
                           "p"=c(total_p/2, sqrt(total_p), total_p))

set.seed(12)
derived_heart_tt_index <- createDataPartition(derived_heart$Target,
                                              p=0.6, list = FALSE)
train_data <- derived_heart[derived_heart_tt_index,]
test_data <- derived_heart[-derived_heart_tt_index,]

# Tune over grid
tune_results <- c()
for(j in 1:dim(tuning_grid)[1]){
  set.seed(12)
  rf_tune <- randomForest(Target~., data=train_data,
                          mtry = tuning_grid$p[j],
                          ntree = tuning_grid$trees[j])
  tune_results[j] <- rf_tune$err.rate[tuning_grid$trees[j], 1]
}

train_tune_results <- cbind(tuning_grid, "oob_error"=tune_results)
best_tune <- train_tune_results[which(tune_results==min(tune_results)),][1,]

# Fit on training use best tune
set.seed(12)
rf_fit <- randomForest(Target~., data=train_data,
                       mtry = best_tune$p,
                       ntree = best_tune$trees)

# Test on test data
test_data$predict_rf <- predict(rf_fit, newdata=test_data)

test_data = test_data %>% 
  mutate(predict_rf = as.numeric(predict_rf))

roc_obj_rf <- 
  roc(response = test_data$Target, 
      predictor = test_data$predict_rf)

best_thres_data <- 
  data.frame(coords(roc_obj_rf, x="best", best.method = c("youden")))


# Plot ROC curve
rf_roc_plot = ggroc(roc_obj_rf)+
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
         paste0("ROC curve for predicting heart disease using Random Forest, on test set\nAUC = ", round(auc(roc_obj_rf),2)))+
  theme_classic()

png("figures/roc_rf.png")
plot(rf_roc_plot)
dev.off()
