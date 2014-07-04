## Analysis script ## 
library(ggplot2)

# Overall plot of the appeals per year.
ggplot(list) + geom_line(aes(date), stat = 'bin') 

# Overall plot of the appeals per year, in facets per type.
ggplot(list) + geom_line(aes(date), stat = 'bin') + facet_wrap(~ appeal_type)