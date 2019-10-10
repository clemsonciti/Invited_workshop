---
title: "R for Psychology"
output: html_document
---
## Introduction to Machine Learning workshop for Psychology

```{r}
install.packages("psych")
library(psych)
```

For the first example, we read data from a remote file server for several hundred subjects on 13 personality scales (5 from the Eysenck Personality Inventory (EPI), 5 from a Big Five Inventory (BFI), the Beck Depression Inventory, and two anxiety scales). The file is structured normally, i.e. rows represent different subjects, columns different variables, and the first row gives subject labels.

```{r, eval=FALSE}
datafilename <- "http://personality-project.org/r/datasets/maps.mixx.epi.bfi.data"
person.data  <- read.table(datafilename,header=TRUE)  #read the data file

names(person.data) 
dim(person.data)
person.data$epiE
subset(person.data,epilie>6)  

```

#### Descriptive analysis

You can also embed analyses, for example:

```{r, eval=FALSE}
summary(person.data)
cor(person.data)
corr.test(person.data)
cor.plot(person.data)
```

### Plot

You can also embed plots, for example:

#### Boxplot
```{r, eval=FALSE}
boxplot(person.data)
```


#### Factor analysis
Factor analysis is a statistical method used to describe variability among observed, correlated variables in terms of a potentially lower number of unobserved variables called factors

It is a theory used in machine learning and related to data mining. The theory behind factor analytic methods is that the information gained about the interdependencies between observed variables can be used later to reduce the set of variables in a dataset.

Factor Analysis using Weighted Least Square (wls)

```{r, eval=FALSE}
data("Thurstone")
f3w <- fa(Thurstone,3,n.obs = 213,fm="wls")
f3w
fa.diagram(f3w)
```

#### Cluster analysis
A common data reduction technique is to cluster cases (subjects). Less common, but particularly useful in psychological research, is to cluster items (variables). This may be thought of as an alternative to factor analysis, based upon a much simpler model. The cluster model is that the correlations between variables reflect that each item loads on at most one cluster, and that items that load on those clusters correlate as a function of their respective loadings on that cluster and items that define different clusters correlate as a function of their respective cluster loadings and the intercluster correlations. Essentially, the cluster model is a Very Simple Structure factor model of complexity one (see VSS).

This function applies the iclust algorithm to hierarchically cluster items to form composite scales. Clusters are combined if coefficients alpha and beta will increase in the new cluster.

Alpha, the mean split half correlation, and beta, the worst split half correlation, are estimates of the reliability and general factor saturation of the test. (See also the omega function to estimate McDonald's coeffients omega hierarchical and omega total)

```{r, eval=FALSE}
data(bfi)
ic <- iclust(bfi[1:25])
pairs.panels(bfi[,1:5],pch='.',gap=0)
```


## Package predpsych
```{r, eval=FALSE}
install.packages("PredPsych")
library(PredPsych)
```

#### Input data: Kinematic data
- The data employ part of the motion capture dataset.
- This dataset was obtained by recording 15 naïve participants performing reach-to-grasp movements towards two differently
sized objects: a small object (i.e., hazelnut) and a large object (i.e., grapefruit).
- Movements were recorded using a nearinfrared camera motion capture system 
- Kinematic features of interest were estimated based on global frame of reference of motion capture system and a local frame
centered on the hand

#### Data description
– Wrist Velocity, defined as the module of the velocity of the wrist marker (mm/sec);
– Wrist Height, defined as the z-component of the wrist marker (mm);
– Grip Aperture, defined as the distance between the marker placed on thumb tip and that placed on the tip of the
index finger (mm);
– x-, y-, and z-thumb, defined as x-, y-, and z-coordinates for the thumb with respect to F-local (mm);
– x-, y-, and z-index, defined as x-, y-, and z-coordinates for the index finger with respect to F-local (mm);
– x-, y-, and z-finger plane, defined as x-, y-, and zcomponents of the thumb-index plane, i.e., the three dimensional
components of the vector that is orthogonal to the plane. This plane is defined as passing through thu0, ind3, and thu4,with components varying between +1 and 1.

**Research questions**

Q1. Do my experimental conditions have discriminatory information?
Q2. Is my discrimination significant?
Q3. Which features/variables can best discriminate between my conditions?
Q4. Do my experimental conditions contain variability?
Q5. Can I represent my data in lower dimensions?


### Q1. Do my experimental variables have discriminatory information?
- This kind of question arises when researchers are interested in understanding whether properties of the collected data (i.e., data
features) encode enough information to discriminate between two or more experimental conditions (i.e., classes or groups).
- Required to determine whether and to what extent data features can be combined to reliably predict classes and, when errors are made, what is the nature of such errors, i.e., which conditions are more likely to be confused with each other

#### Using LDA
- The simplest algorithm for classification based analysis is the Linear Discriminant Analysis (LDA). LDA builds a model composed
of a number of discriminant functions based on linear combinations of data features that provide the best discrimination between two ormore classes.
- The aim of LDAis thus to combine the data feature scores in a way that a single new composite variable, the discriminant function, is produced 
- LDA is closely related to logistic regression analysis

```{r, eval=FALSE}
data(KinData)
LDAMod <- LinearDA(Data = KinData,classCol = 1,selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout")

```

#### Using SVM
- SVM is more sophisticated algorithm
- Instead of finding a linear function that separates the data classes, SVMs try to find the optimal function that is farthest from data points of any class
- SVMs use a kernel function (linear, polynomial, radial basis) to project the data points into higher dimensional space.

```{r, eval=FALSE}
SVMMod <- classifyFun(Data = KinData,classCol = 1,selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout")
```

#### DecisionTree
- DT models fall under the general Tree-based methods involving generation of a recursive binary tree
- From the input data, DT models build a set of logical **if…then** rules that permit accurate prediction of the input cases.
- It is more flexible than Regression method
```{r, eval=FALSE}
DTMod <- DTModel(Data = KinData,classCol = 1,
                 selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),tree="CARTCV",cvType = "holdout")
```

### Q2. Is my discrimination successful?
- After obtaining classification result, a researcher might ask if the results obtained reflect a real class structure in the data, i.e., whether they are statistically significant.
- This is especially important when the data, as in most psychological research, have a high dimensional nature with a low number of observations

#### Permutation testing
- Permutation tests are a set of nonparametric methods for hypothesis testing without assuming a particular distribution
- In case of classification analysis, this requires shuffling the labels of the dataset (i.e., randomly shuffling classes/conditions between observations) and calculating the accuracies obtained. This process is repeated a number of times (usually 1,000 or more times)

```{r, eval=FALSE}
PermMod <- ClassPerm(Data = KinData,classCol = 1,
                 selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout",
                 nSims = 100)
```

### Q3. Which features/variables can best discriminate between the conditions?
- There are cases in which hundreds of features are used as inputs for the classification and many of them might not contribute (or not contribute equally) to the classification
- This is because while certain features might favor discrimination, others might contain mere noise and hinder the classification
- In such a case, it is advisable to perform some sort of feature selection to identify the features that are most important for a given
analysis.

#### Using F-scores
- One of the measures commonly used for feature selection is the Fisher score (F-score)
- F-score provides a measure of how well a single feature at a time can discriminate between different
- The higher the F-score, the better the discriminatory power of that feature classes.

```{r, eval=FALSE}
FSMod <- fscore(Data = KinData, classCol = 1,
                 featureCol = c(1,2,12,22,32,42,52,62,72,82,92,102,112))
FSMod
```

### Q4. Does my experimental conditions contain variability?
- Variability in data has long been considered as unwanted noise arising from inherent noise
- Consequently, many researchers are attempting to gain a better understanding of their results in terms of intrinsic variability of the data. When the source of this variability is not clear, researchers have to rely on exploratory approaches such as clustering or
non-negative factorization.

#### Clustering approach
- Clustering approaches partition data features in subsets or clusters based on data similarity.
- Unlike classification analyses, clustering analysis does not require class labels but utilizes the data features to predict
subsets and is thus an unsupervised learning approach

```{r, eval=FALSE}
initial_col <- c(2,12,22,32,42,52,62,72,82,92,102,112)
for (i in 1:9){
  cluster_time <- ModelCluster(Data = KinData[,initial_col+i],G=1:12,silent=TRUE)
  print(paste0('The optimal number of clusters at ',(i+1)*10,' are ', cluster_time$G))
}
```

```{r, eval=FALSE}
library(ggplot2)
library(factoextra)
library(purrr)

fviz_nbclust(KinData[,initial_col], kmeans, method = "wss")
km10 <- kmeans(KinData[,initial_col],9,nstart=20)
fviz_cluster(km10,geom="point",data=KinData[,initial_col])

fviz_nbclust(KinData[,initial_col+9], kmeans, method = "wss")
km100 <- kmeans(KinData[,initial_col+9],5,nstart=200)
fviz_cluster(km100,geom="point",data=KinData[,initial_col+9])

```

### Q5. Can I represent my data in lower dimensions?
- Variables in such data often are correlated with each other making the interpretation of the effects difficult
- Problems of over-fitting

#### Dimension Reduction
Generating relatively independent data features, obtaining higher and more generalizable classification results (lower prediction errors)

```{r, eval=FALSE}
Wrist_velocity <- DimensionRed(Data = KinData, selectedCols = 2:11,
                               outcome=KinData[,"Object.Size"],plot=TRUE)

Grip_Aperture <- DimensionRed(Data = KinData, selectedCols = 12:21,
                              outcome = KinData[,"Object.Size"],plot=TRUE)
```

