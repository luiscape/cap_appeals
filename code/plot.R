## Plotting script ##



world_spark_plot_scale <- ggplot(world, aes(period, value, color = source)) + theme_bw() +
    geom_line(stat = 'identity', size = 1.3) +
    facet_wrap(~ source, scale = 'free_y') +
    ylab("Number of Disaster Events") + xlab("") +
    theme(panel.border = element_rect(linetype = 0),
          strip.background = element_rect(colour = "white", fill = "white"),
          panel.background = element_rect(colour = "white"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.title = element_blank(),
          axis.title.y = element_text(size = 7, face = 'italic'),
          legend.key = element_blank()) +
    scale_x_continuous(limits = c(1950, 2014),
                       labels = c(1950, 1960, 1970, 1980, 1990, 2000, 2014),
                       breaks = c(1950, 1960, 1970, 1980, 1990, 2000, 2014))