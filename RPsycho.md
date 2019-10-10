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

### Q1. Do my experimental variables have discriminatory information?
Using LDA

```{r, eval=FALSE}
data(KinData)
LDAMod <- LinearDA(Data = KinData,classCol = 1,selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout")

```


Using SVM
```{r, eval=FALSE}
SVMMod <- classifyFun(Data = KinData,classCol = 1,selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout")
```


DecisionTree
```{r, eval=FALSE}
DTMod <- DTModel(Data = KinData,classCol = 1,
                 selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),tree="CARTCV",cvType = "holdout")
```

Q2. Is my discrimination successful?
### Permutation testing
```{r, eval=FALSE}
PermMod <- ClassPerm(Data = KinData,classCol = 1,
                 selectedCols = c(1,2,12,22,32,42,52,62,72,82,92,102,112),cvType = "holdout",
                 nSims = 100)
```

Q3. Which features/variables can best discriminate between the conditions?
### Using F-scores
```{r, eval=FALSE}
FSMod <- fscore(Data = KinData, classCol = 1,
                 featureCol = c(1,2,12,22,32,42,52,62,72,82,92,102,112))
FSMod
```

Q4. Does my experimental conditions contain variability?

### Clustering approach
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

Q5. Can I represent my data in lower dimensions?
### Dimension Reduction
```{r, eval=FALSE}
Wrist_velocity <- DimensionRed(Data = KinData, selectedCols = 2:11,
                               outcome=KinData[,"Object.Size"],plot=TRUE)

Grip_Aperture <- DimensionRed(Data = KinData, selectedCols = 12:21,
                              outcome = KinData[,"Object.Size"],plot=TRUE)
```

