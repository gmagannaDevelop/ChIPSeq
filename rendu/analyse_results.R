
library(tidyverse)

paramTable <- read.table("results.txt", header = T)
criterium.name <- "before.ratio"
vecProp <- paramTable[, criterium.name] <- paramTable[,"bPeaksNumber_beforeFeatures"] / paramTable[, "bPeaksNumber"]
paramTable[, "in.ratio"] <- paramTable[,"bPeaksNumber_beforeFeatures"] / paramTable[, "bPeaksNumber"]
maxima <- vecProp == max(vecProp)
which(maxima)

param.tib <- as_tibble(paramTable)


.params <- c(
  "IPcoeff", 
  "controlCoeff",
  "log2FC",
  "averageQuantiles",
  "bPeaksNumber",
  criterium.name
)

reg.table <- paramTable[, .params]
reg.tib <- as_tibble(reg.table)
reg.formula <- paste(criterium.name, "~ . - bPeaksNumber")
param.reg <- lm(reg.formula, data = reg.table)

s.param.reg <- summary(param.reg)
s.param.reg

reg.tib %>% filter(log2FC == 3) %>% 
  filter(averageQuantiles > 0.8 & averageQuantiles < 0.95) -> candidates.tib


reg.tib %>% filter(log2FC == 3) %>% 
  ggplot(aes(x=averageQuantiles, y=bPeaksNumber)) +
  geom_smooth() +
  geom_jitter(aes(colour=before.ratio)) 

reg.tib %>% filter(averageQuantiles > mean(averageQuantiles)) %>%
  ggplot(aes(x=log2FC, y=bPeaksNumber)) +
  geom_smooth() +
  geom_jitter(aes(colour=before.ratio)) 

opt.table <- paramTable[which(maxima), .params]
opt.table

reg.total.bpeaks <- lm(bPeaksNumber ~ . - before.ratio, data=reg.table)
s.reg.total <- summary(reg.total.bpeaks)
s.reg.total

reg.tib %>% filter(before.ratio > 0.7 & bPeaksNumber > 15) -> final.candidates
