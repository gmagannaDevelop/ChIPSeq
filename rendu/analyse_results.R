
library(tidyverse)

# read the results from our parallel calls to bpeaks :
paramTable <- read.table("results.txt", header = T)
# Our new variable which we are trying to maximise :
# the proportion of peaks found before the gene's region
# i.e. upstream promoters
criterium.name <- "before.ratio"
vecProp <- paramTable[, criterium.name] <- paramTable[,"bPeaksNumber_beforeFeatures"] / paramTable[, "bPeaksNumber"]
# the contrary, on-sequence promoters
paramTable[, "in.ratio"] <- paramTable[,"bPeaksNumber_beforeFeatures"] / paramTable[, "bPeaksNumber"]
maxima <- vecProp == max(vecProp)
which(maxima)

# convert to tibble in order to use tidyverse's function
param.tib <- as_tibble(paramTable)

# select a subset of interesting parameters
# (the ones we are tweaking + bPeaksNumber + before.ratio)
.params <- c(
  "IPcoeff", 
  "controlCoeff",
  "log2FC",
  "averageQuantiles",
  "bPeaksNumber",
  criterium.name
)

# create a regression dataframe subsetting the original one
reg.table <- paramTable[, .params]
# a tibble is just tidyverse's version of the dataframe
reg.tib <- as_tibble(reg.table)
# we create a formula using "criterium.name" 
# (I changed the parameter's name many times,
# so it was better to use metaprogramming)
reg.formula <- paste(criterium.name, "~ . - bPeaksNumber")
# this regression tries to find a relationship
# between bPeaks and our parameters
param.reg <- lm(reg.formula, data = reg.table)

# The summary object is more informative than the plain regression
s.param.reg <- summary(param.reg)
s.param.reg
#Call:
#  lm(formula = reg.formula, data = reg.table)
#
#Residuals:
#  Min       1Q   Median       3Q      Max 
#-0.16631 -0.06102 -0.01373  0.04176  0.17356 
#
#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept)      -1.0504439  0.0902369 -11.641   <2e-16 ***
#  IPcoeff           0.0010923  0.0051983   0.210    0.834    
#controlCoeff      0.0008412  0.0038860   0.216    0.829    
#log2FC            0.2503281  0.0154194  16.235   <2e-16 ***
#  averageQuantiles  1.0641232  0.0918263  11.588   <2e-16 ***
#  ---
#  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
#Residual standard error: 0.07849 on 112 degrees of freedom
#Multiple R-squared:  0.794,	Adjusted R-squared:  0.7866 
#F-statistic: 107.9 on 4 and 112 DF,  p-value: < 2.2e-16

# some quasi-optimal candidates :
reg.tib %>% filter(log2FC == 3) %>% 
  filter(averageQuantiles > 0.8 & averageQuantiles < 0.95) -> candidates.tib

# see the influence of the two significant parameters
# 'averageQuantiles' and 'log2FC'
# on the total number of peaks and before.ratio 
plot1 <- reg.tib %>% filter(log2FC == 3) %>% 
  ggplot(aes(x=averageQuantiles, y=bPeaksNumber)) +
  geom_smooth() +
  geom_jitter(aes(colour=before.ratio)) 

plot2 <- reg.tib %>% filter(averageQuantiles > mean(averageQuantiles)) %>%
  ggplot(aes(x=log2FC, y=bPeaksNumber)) +
  geom_smooth() +
  geom_jitter(aes(colour=before.ratio)) 

# pseudo-optimal values
opt.table <- paramTable[which(maxima), .params]
opt.table

# estimate the relationship between total number of peaks
# and the parameters
reg.total.bpeaks <- lm(bPeaksNumber ~ . - before.ratio, data=reg.table)
s.reg.total <- summary(reg.total.bpeaks)
s.reg.total
# Call:
#   lm(formula = bPeaksNumber ~ . - before.ratio, data = reg.table)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -94.841 -35.308  -7.845  22.980 286.612 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)      1261.82058   66.18950  19.064   <2e-16 ***
#   IPcoeff            -7.17544    3.81299  -1.882   0.0625 .  
# controlCoeff        0.08333    2.85038   0.029   0.9767    
# log2FC           -118.88018   11.31025 -10.511   <2e-16 ***
#   averageQuantiles -954.98286   67.35530 -14.178   <2e-16 ***
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 57.57 on 112 degrees of freedom
# Multiple R-squared:  0.7531,	Adjusted R-squared:  0.7443 
# F-statistic: 85.41 on 4 and 112 DF,  p-value: < 2.2e-16

# Final candidates to perform peak-calling optimally
reg.tib %>% filter(before.ratio > 0.7 & bPeaksNumber > 15) -> final.candidates
