## Script to download all appeal documents. ##
## the list of links should be in the data folder. #

link_list <- read.csv('data/link_list.csv')
link_list$file_name <- gsub('(.+?)/', "", link_list$href)

for(i in 1:nrow(link_list)) {
    url <- as.character(link_list$href[i])
    file_name <- paste0('data/appeal_documents/', link_list$file_name[i])
	download.file(url, file_name, method = 'curl')
}