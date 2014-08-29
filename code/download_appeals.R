## Script to download all appeal documents. ##
## the list of links should be in the data folder. #

# checking for dependencies
if (require(XML) == F) { install.packages('XML'); library(XML) } else library(XML)
if (require(RCurl) == F) { install.packages('RCurl'); library(RCurl) } else library(RCurl)

# change this if running on ScraperWiki
b_folder = ''

# linking test suite
source(paste(b_folder, 'code/test.R', sep =""))

appealsList <- read.csv(paste(b_folder, 'data/appeals_list.csv', sep = ""))

# function to download documents
getDocuments <- function(df = NULL, f = F) {
  # check if file has been downloaded already
  if (f == F) {
    files_d <- list.files(paste(b_folder, 'data/appeal_documents/',sep = ""))
  } else files_d = NA
  for(i in 1:nrow(df)) {
    url <- as.character(df$url[i])
    file_path <- paste0(b_folder, 'data/appeal_documents/', df$file_name[i])
    if (df$file_name[i] %in% files_d) {
      message('You already have the file ', df$file_name[i])
      message('Skipping...')
      next
    }
    else {
      tryCatch({
        message('Downloading: ', file_path, "--", i, "/", nrow(df))
        download.file(url, file_path, method = 'wget', quiet = TRUE)
      },
      error = function(cond) {
        message('Error on: ', file_path, ' Retrying.\n'); i = i - 1
      },
      finally = {
        message("ok.")
      })
    }
  }
}
message('Downloading the documents.')
system.time(getDocuments(appealsList))

# running test
testDocuments()

message('Done!')