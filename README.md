# machine_learning_classifier using R
KNN and RF model classifiers

## Data preprocessing
*	A dataset that compiled a group of participants' particulars and lifestyle habits, consisting of both categorical and numerical variables, was used.
*	Missing data was imputed.
*	One-hot encoding was carried out to convert categorical to numerical variables.
*	Data was scaled after being converted.
*	A correlation matrix was plot to identify any variables that may not have had any correlation to weight classification (target variable).

## Model Implementation
*	2 classifier models were built and tested, k-nearest neighbor (KNN) and random forest (RF)
*	Various ratios were tested when splitting the data into training and test sets but settled on a 70% - 30% split.
*	The square root of the number of samples was selected as the k-value.
*	A short loop was also written to plot the accuracy of the model vs the k-value as a means of visualizing the performance of the model with different parameters
*	For the RF model, the same split ratio was used as it was found to be optimal.
*	The RF model was tuned, testing various tree number values and different number of variables at each split.
*	Once the optimum values were obtained, the 2 models were benchmarked against one another with the RF model outperforming the KNN model in the case of this study.
 
