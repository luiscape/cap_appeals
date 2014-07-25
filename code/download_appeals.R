## Script to download all appeal documents. ##
## the list of links should be in the data folder. #

link_list <- read.csv('data/link_list.csv')
link_list$file_name <- gsub('(.+?)/', "", link_list$href)

getDocuments <- function() {
    pb <- txtProgressBar(min = 0, max = nrow(link_list), char = '.')
    for(i in 1:nrow(link_list)) {
        setTxtProgressBar(pb, i)
        url <- as.character(link_list$href[i])
        file_name <- paste0('data/appeal_documents/', link_list$file_name[i])
        download.file(url, file_name, method = 'wget', quiet = TRUE)
    }
}
data <- Sys.time(getDocuments())


testDocuments <- function(list = link_list, verbose = FALSE, try_again = FALSE) {
    files_d <- list.files('data/appeal_documents/')
    diff <- nrow(link_list) - length(files_d)
    message(paste(diff, 'files were not downloaded. They may be duplicates.'))
    
    # assembling a list of missing files
    file_list <- data.frame(hrefs = ifelse(list$file_name %in% files_d == FALSE, 
                                           as.character(list$hrefs), 
                                           NA), 
                            file_name = ifelse(list$file_name %in% files_d == FALSE, 
                                               as.character(list$file_name), 
                                               NA))
    
    file_list <- na.omit(file_list)
    
    # print the undownloaded list
    if (verbose == TRUE) {
        message('Checking for duplicates ...')
        if (nrow(file_list) > 0) print(file_list)
        else message('All files were downloaded. All missing are duplicates.')
    }
    
    # try again
    if (try_again == TRUE) {
        for(i in 1:nrow(file_list)) {
            setTxtProgressBar(pb, i)
            url <- as.character(file_list$href[i])
            file_name <- paste0('data/appeal_documents/', file_list$file_name[i])
            download.file(url, file_name, method = 'wget', quiet = TRUE)
        }
    }
    message('Everything is OK. :-)')
}

testDocuments(verbose = TRUE)
