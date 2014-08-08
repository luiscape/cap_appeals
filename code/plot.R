## Plotting script ##
library(ggplot2)

# loading data
data <- read.csv('data/appeals_list.csv')
data$date <- as.Date(data$date)

## plotting ##
# bar plot: number of documents by source
bar_plot_source <- ggplot(data, aes(date, fill = appeal_type)) + theme_bw() +
    geom_bar(stat = 'bin', size = 1.3) +
    facet_wrap(~ appeal_type) +
    ylab("Number of Documents") + xlab("") +
    theme(panel.border = element_rect(linetype = 0),
          strip.background = element_rect(colour = "white", fill = "white"),
          panel.background = element_rect(colour = "white"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.title = element_blank(),
          axis.title.y = element_text(size = 7, face = 'italic'),
          legend.key = element_blank())

ggsave('plot/bar_plot_source.png', bar_plot_source, height = 3.05, width = 13.35, units = 'in')


# bar plot: number of documents by source, but colored by country.
bar_plot_country <- ggplot(data, aes(date, fill = iso3)) + theme_bw() +
    geom_bar(stat = 'bin', size = 1.3) +
    facet_wrap(~ appeal_type) +
    ylab("Number of Documents") + xlab("") +
    theme(panel.border = element_rect(linetype = 0),
          strip.background = element_rect(colour = "white", fill = "white"),
          panel.background = element_rect(colour = "white"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.title = element_blank(),
          legend.key = element_blank(),
          legend.key = element_blank(),
          legend.position = "none",
          axis.title.y = element_text(size = 7, face = 'italic'))

ggsave('plot/bar_plot_country.png', bar_plot_country, height = 3.05, width = 13.35, units = 'in')


# step plot by country
country_plot <- ggplot(data, aes(date, color = appeal_type)) + theme_bw() +
    geom_step(stat = 'bin', size = 1.3) +
    facet_wrap(~ iso3) +
    ylab("Number of Documents") + xlab("") +
    theme(panel.border = element_rect(linetype = 0),
          strip.background = element_rect(colour = "white", fill = "white"),
          panel.background = element_rect(colour = "white"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.title = element_blank(),
          legend.key = element_blank(),
          legend.position = "none",
          axis.title.y = element_text(size = 7, face = 'italic'),
          axis.text.x = element_text(angle = 90))

ggsave('plot/steps_country.png', country_plot, height = 9.12, width = 15.93, units = 'in')



# total appeals per country
country_s <- as.data.frame(table(data$iso3))
names(country_s) <- c('iso3', 'count')
country_s <- country_s[order(- country_s$count, country_s$iso3),]

bar_plot_country <- ggplot(country_s, aes(reorder(country_s$iso3, - country_s$count), count)) + 
    theme_bw() +
    geom_bar(stat = 'identity', size = 1.3, fill = '#ED8600') +
#     facet_wrap(~ appeal_type) +
    ylab("Number of Documents") + xlab("") +
    theme(panel.border = element_rect(linetype = 0),
          strip.background = element_rect(colour = "white", fill = "white"),
          panel.background = element_rect(colour = "white"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.title = element_blank(),
          legend.key = element_blank(),
          legend.key = element_blank(),
          legend.position = "none",
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title.y = element_text(size = 7, face = 'italic'))

ggsave('plot/bar_plot_country.png', bar_plot_country, height = 3.05, width = 13.35, units = 'in')
