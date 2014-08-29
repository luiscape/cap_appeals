## Script for extracting data from PDF documents.
library(tm)
library(ggplot2)

# fetching all files from directory. 
meta_pages <- read.csv('data/appeal_documents/meta_pages.txt', header = F)
names(meta_pages) <- c('doc_name', 'n_pages')
meta_creationdate <- read.csv('data/appeal_documents/meta_creationdate.txt', header = F)
names(meta_creationdate) <- c('doc_name', 'creation_date')
meta_moddate <- read.csv('data/appeal_documents/meta_moddate.txt', header = F)
names(meta_moddate) <- c('doc_name', 'mod_date')

x <- merge(meta_pages, meta_creationdate)
meta <- merge(x, meta_moddate)

# converting dates
meta$mod_date <- as.POSIXct(meta$mod_date, format = "%a %b %d %T %Y")
meta$creation_date <- as.POSIXct(meta$creation_date, format = "%a %b %d %T %Y")


# detecting outliers
# function to detect outliers: 3 times the standard deviation
checkOutliers <- function(x) {
    abs(x - mean(x,na.rm=TRUE)) > 3*sd(x,na.rm=TRUE)
}

# use function over all data
meta$is_outlier <- checkOutliers(meta$n_pages)

# writing CSV
write.csv(meta, 'data/appeals_metadata.csv', row.names = F)




## plotting ##
# histogram with the number of pages
ggplot(meta) + theme_bw() +
    geom_histogram(aes(n_pages, fill = is_outlier), binwidth = 10) + 
    ylab('Count') + xlab('Number of Pages per Document') +
    scale_x_continuous(breaks = seq(from=0, to=552, by=20))

# timeline with the doc creation dates
# but also adding the official publication date from the title
# the results show that the production and publishing
# date of the documents don't seem to be very different.

appeals_list <- read.csv('data/appeals_list.csv')
appeals_list$date <- as.POSIXct(appeals_list$date)

ggplot(meta) + theme_bw() +
    geom_line(aes(creation_date), stat = 'bin', size = 1.3, color = "#CCCCCC") + 
    geom_line(aes(mod_date), stat = 'bin', size = 1.3, color = "#1EBFB3") + 
    geom_line(data = appeals_list, aes(date), 
              stat = 'bin', 
              size = 1.3, color = "#F2645A")
