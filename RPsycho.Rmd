---
title: "R for Psychology"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


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

## Descriptive analysis

You can also embed analyses, for example:

```{r, eval=FALSE}
summary(person.data)
cor(person.data)
corr.test(person.data)
cor.plot(person.data)
```

## Plot

You can also embed plots, for example:
I will be using ggplot2 for better plot

### Boxplot
```{r, eval=FALSE}
boxplot(person.data)
```


### Factor analysis
Factor Analysis using Weighted Least Square (wls)

```{r, eval=FALSE}
data("Thurstone")
f3w <- fa(Thurstone,3,n.obs = 213,fm="wls")
f3w
fa.diagram(f3w)
```

### Cluster analysis

```{r, eval=FALSE}
data(bfi)
ic <- iclust(bfi[1:25])
pairs.panels(bfi[,1:5],pch='.',gap=0)
```


### Package predpsych
```{r, eval=FALSE}
install.packages("PredPsych")
library(PredPsych)
```

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

Q5. Can I represent my data in lower dimensions?
### Dimension Reduction
```{r, eval=FALSE}
Wrist_velocity <- DimensionRed(Data = KinData, selectedCols = 2:11,
                               outcome=KinData[,"Object.Size"],plot=TRUE)

Grip_Aperture <- DimensionRed(Data = KinData, selectedCols = 12:21,
                              outcome = KinData[,"Object.Size"],plot=TRUE)
```

