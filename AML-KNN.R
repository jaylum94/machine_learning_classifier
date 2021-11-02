dataKNN <- read.csv("AMLDataset.csv")
sum(is.na(dataKNN))
colSums(sapply(dataKNN,is.na))
is.na(dataKNN) <- dataKNN == ''

library(DataExplorer)
str(dataKNN)
plot_missing(dataKNN)
dataKNN$SMOKE = factor(dataKNN$SMOKE,
                       levels = c('no', 'yes'),
                       labels = c(0, 1))

dataKNN$CALC = factor(dataKNN$CALC,
                      levels = c('no', 'Sometimes', "Frequently"),
                      labels = c(0, 1, 2))

dataKNN$MTRANS = factor(dataKNN$MTRANS,
                        levels = c('Walk', 'Bike','Motorbike','Automobile', 'Public_Transportation'),
                        labels = c(0, 1, 2, 3, 4))

dataKNN$SCC = factor(dataKNN$SCC,
                       levels = c('no', 'yes'),
                       labels = c(0, 1))

dataKNN$Gender = factor(dataKNN$Gender,
                        levels = c('Male', 'Female'),
                        labels = c(0, 1))

dataKNN$FAVC = factor(dataKNN$FAVC,
                       levels = c('no', 'yes'),
                       labels = c(0, 1))

dataKNN$NObeyesdad = factor(dataKNN$NObeyesdad,
                        levels = c('Insufficient_Weight', 'Normal_Weight', 'Overweight_Level_I', 'Overweight_Level_II', 'Obesity_Type_I', 'Obesity_Type_II', 'Obesity_Type_III'),
                        labels = c(0, 1,2,3,4,5,6))

dataKNN$family_history_with_overweight = factor(dataKNN$family_history_with_overweight,
                        levels = c('no', 'yes'),
                        labels = c(0, 1))

dataKNN$CAEC = factor(dataKNN$CAEC,
                       levels = c('no', 'Sometimes', "Frequently","Always"),
                       labels = c(0, 1, 2, 3))

head(dataKNN)


library(mice)
micedataset <- mice(dataKNN, defaultMethod = c("pmm", "logreg", "polyreg"), m=5)
micedataset$method
dk <- complete (micedataset)
sum(is.na(dk))
plot_missing(dk)

dk2 <- rapply(object = dk, f = round, classes = "numeric", how = "replace", digits = 2) 

library(dplyr)
dk3 <- mutate_all(dk2, function(x) as.numeric(as.character(x)))
str(dk3)

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }

dk4 <- as.data.frame(lapply(dk3, normalize))


plot_correlation(dk4,'continuous')

dk4$NObeyesdad <- as.factor(dk4$NObeyesdad)

str(dk4)

set.seed(123)
datasp <- sample(1:nrow(dk4),size=nrow(dk4)*0.7,replace = FALSE) 
train.obes <- dk4[datasp,] 
test.obes <- dk4[-datasp,] 
train.obes_labels <- dk4[datasp,17] 
test.obes_labels <-dk4[-datasp, 17]

library(class)
NROW(train.obes_labels)
knn.38 <- knn(train=train.obes, test=test.obes, cl=train.obes_labels, k=38)
knn.39 <- knn(train=train.obes, test=test.obes, cl=train.obes_labels, k=39)

#ACC.38 <- 100 * sum(test.obes_labels == knn.38)/NROW(test.obes_labels)
#ACC.39 <- 100 * sum(test.obes_labels == knn.39)/NROW(test.obes_labels)

library(caret)
table(knn.38 ,test.obes_labels)
table(knn.39 ,test.obes_labels)
confusionMatrix(table(knn.38 ,test.obes_labels))
confusionMatrix(table(knn.39 ,test.obes_labels))


i=1
k.optm=1
for (i in 1:50){
   knn.mod <- knn(train=train.obes, test=test.obes, cl=train.obes_labels, k=i)
   k.optm[i] <- 100 * sum(test.obes_labels == knn.mod)/NROW(test.obes_labels)
   k=i
   cat(k,'=',k.optm[i],'
')}
plot(k.optm, type="b", xlab="K- Value",ylab="Accuracy level")
