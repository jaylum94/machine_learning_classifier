dataRF <- read.csv("ObesityDataSet.csv")
sum(is.na(dataRF))
colSums(sapply(dataRF,is.na))
is.na(dataRF) <- dataRF == ''

library(DataExplorer)
str(dataRF)
plot_missing(dataRF)
dataRF$SMOKE = factor(dataRF$SMOKE,
                        levels = c('no', 'yes'),
                        labels = c(0, 1))

dataRF$CALC = factor(dataRF$CALC,
                       levels = c('no', 'Sometimes', "Frequently"),
                       labels = c(0, 1, 2))
dataRF$MTRANS = factor(dataRF$MTRANS,
                         levels = c('Walk', 'Bike','Motorbike','Automobile', 'Public_Transportation'),
                         labels = c(0, 1, 2, 3, 4))

dataRF$SCC = factor(dataRF$SCC,
                      levels = c('no', 'yes'),
                      labels = c(0, 1))

dataRF$Gender = factor(dataRF$Gender,
                         levels = c('Male', 'Female'),
                         labels = c(0, 1))

dataRF$FAVC = factor(dataRF$FAVC,
                       levels = c('no', 'yes'),
                       labels = c(0, 1))

dataRF$NObeyesdad = factor(dataRF$NObeyesdad,
                             levels = c('Insufficient_Weight', 'Normal_Weight', 'Overweight_Level_I', 'Overweight_Level_II', 'Obesity_Type_I', 'Obesity_Type_II', 'Obesity_Type_III'),
                             labels = c(0, 1,2,3,4,5,6))

dataRF$family_history_with_overweight = factor(dataRF$family_history_with_overweight,
                                                 levels = c('no', 'yes'),
                                                 labels = c(0, 1))

dataRF$CAEC = factor(dataRF$CAEC,
                       levels = c('no', 'Sometimes', "Frequently","Always"),
                       labels = c(0, 1, 2, 3))

head(dataRF)

library (mice)
micedatasetRF <- mice(dataRF, defaultMethod = c("pmm", "logreg", "polyreg"), m=3)
dr <- complete (micedatasetRF)
sum(is.na(dr))
plot_missing(dr)

dr2 <- rapply(object = dr, f = round, classes = "numeric", how = "replace", digits = 2) 

library(randomForest)
str(dr2)
set.seed(123)
dataspRF <- sample(1:nrow(dr2),size=nrow(dr2)*0.7,replace = FALSE)
train.obes.RF <- dr2[dataspRF,] 
test.obes.RF <- dr2[-dataspRF,] 

RF <- randomForest(NObeyesdad ~ ., data=train.obes.RF)
RF

prediction = predict(RF, newdata = test.obes.RF[-17] )
cm = table(test.obes.RF[,17], prediction)
confusionMatrix(cm)
 
mtry.opt <- tuneRF(dr2[-17],dr2$NObeyesdad, ntreeTry=500,
               stepFactor=2,improve=0.01, trace=TRUE, plot=TRUE, doBest = TRUE)
mtry.opt

RF.opt <- randomForest(NObeyesdad~., data=train.obes.RF, mtry = 8, ntree = 1000)
RF.opt

prediction.opt = predict(RF.opt, newdata = test.obes.RF[-17] )
cm.opt = table(test.obes.RF[,17], prediction.opt)
cm.opt
confusionMatrix(cm.opt)
