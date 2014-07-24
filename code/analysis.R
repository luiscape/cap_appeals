## Analysis script ## 
library(ggplot2)

# 
data <- read.csv('data/appeals_list.csv')

nas <- data[is.na(data$iso3) == TRUE, ]
