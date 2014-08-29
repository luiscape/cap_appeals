# Script to download all CAP appeals from the UNOCHA website.
# http://www.unocha.org/cap/appeals/by-appeal/results?page=0
# There are 490+ appeals.

# checking for dependencies
if (require(XML) == F) { install.packages('XML'); library(XML) } else library(XML)
if (require(RCurl) == F) { install.packages('RCurl'); library(RCurl) } else library(RCurl)
if (require(countrycode) == F) { install.packages('countrycode'); library(countrycode) } else library(countrycode)

# change this if running on ScraperWiki
b_folder = ''

# loading test suite -- to be run manually
source(paste(b_folder, 'code/test.R', sep =""))

###################################################
###################################################
############## Scraping Appeals List ##############
###################################################
###################################################
       
# assembling appeals list from UNOCHA's website
# the scraper spins throught all the pages in UNOCHA CAP
# website and extracts the table information from each appeal.
# it also adds a unique code for each appeal. 
# other functions below will encode an appeal based on its country name
# or crisis name, add a time stamp based on the appeals title, and
# add a link to its source document, and a document name. 

scrapeList <- function(verbose = FALSE) {
 base_url <- 'http://www.unocha.org/cap/appeals/by-appeal/results'
 page <- '?page='  # 490+ appeals in 10 pages -- starts at 0.
 
 # CAP appeals go until page 7
 message('Assembling a list of CAP documents.')
 start = 0
 end = 7
 pb <- txtProgressBar(min = 0, max = end, style = 3, char = ".")
 for(i in start:end) {
   if (verbose == TRUE) message(paste('Page:', i))
   setTxtProgressBar(pb, i)
   url <- paste0(base_url, page, i)
   if (i == end) {
     table <- getNodeSet(htmlParse(url),"//table")[[1]]
     doc <- readHTMLTable(table, useInternal = TRUE)
   } 
   else doc <- readHTMLTable(getURL(url), useInternal = TRUE)
   doc <- data.frame(doc)
   doc <- doc[1]
   colnames(doc)[1] <- 'document_name'
   if (i == start) cap_list <- doc
   else cap_list <- rbind(cap_list, doc)
 }
 names(cap_list) <- 'document_name'
 cap_list$id <- paste0('CAP-', 1:nrow(cap_list))
 cap_list$appeal_type <- 'Consolidated Appeal'
 
 
 # Flash appeals from page 7 until page 9
 start = 7
 end = 8
 message('Assembling a list of Flash Appeals documents.')
 if (verbose == TRUE) message(paste('Page:', i))
 pb <- txtProgressBar(min = start, max = end, style = 3, char = ".")
 for(i in start:end){
   setTxtProgressBar(pb, i)
   url <- paste0(base_url, page, i)
   if (i == start) { 
     table <- getNodeSet(htmlParse(url),"//table")[[2]]
     doc <- readHTMLTable(table, useInternal = TRUE)
   }
   else { 
     doc <- readHTMLTable(getURL(url), useInternal = TRUE)
   }
   doc <- data.frame(doc[[1]])
   doc <- doc[1]
   colnames(doc)[1] <- 'document_name'
   if (i == start) flash_list <- doc
   else flash_list <- rbind(flash_list, doc)
 }
 names(flash_list) <- 'document_name'
 flash_list$id <- paste0('FLA-', 1:nrow(flash_list))
 flash_list$appeal_type <- 'Flash Appeal'
 
 
 # Other appeals only on page 9.
 start = 8
 end = 9
 message('Assembling a list of Other Appeals documents.')
 pb <- txtProgressBar(min = start, max = end, style = 3, char = ".")
 for(i in start:end){
   if (verbose == TRUE) message(paste('Page:', i))
   setTxtProgressBar(pb, i)
   url <- paste0(base_url, page, i)
   if (i == start) { 
     table <- getNodeSet(htmlParse(url),"//table")[[2]]
     doc <- readHTMLTable(table, useInternal = TRUE)
     doc <- doc[1]
   }
   else { 
     doc <- readHTMLTable(getURL(url), useInternal = TRUE)
     doc <- data.frame(doc[[1]])
     doc <- doc[1]
   }
   colnames(doc)[1] <- 'document_name'
   if (i == start) other_list <- doc
   else other_list <- rbind(other_list, doc)
 }
 names(other_list) <- 'document_name'
 other_list$id <- paste0('OTH-', 1:nrow(other_list))
 other_list$appeal_type <- 'Other appeals'
 
 message('Done.')
 z_list <- rbind(cap_list, flash_list, other_list)
 return(z_list)
}
appealsList <- scrapeList()

# performing tests
testCount()

###################################################
###################################################
################ Adding ISO3 codes ################
###################################################
###################################################
# Around 50 won't encode with the countrycodes package.
# This function deals with the exceptions
addISO3 <- function(df = NULL) {
 message('Adding country codes.\n')
 
 # running the general package
 df$iso3 <- countrycode(df$document_name, 'country.name', 'iso3c')
 
 ## correcting regex errors
 # country basis
 df$iso3 <- ifelse(is.na(df$iso3), 'WLD', df$iso3)
 df$iso3 <- ifelse(grepl('Cameroun', df$document_name), 'CMR', df$iso3)
 df$iso3 <- ifelse(grepl('Sénégal', df$document_name), 'SEN', df$iso3)
 df$iso3 <- ifelse(grepl('Mauritanie', df$document_name), 'MRT', df$iso3)
 df$iso3 <- ifelse(grepl('Mali', df$document_name), 'MLI', df$iso3)
 df$iso3 <- ifelse(grepl('Haïti', df$document_name), 'HTI', df$iso3)
 df$iso3 <- ifelse(grepl('Mindanao', df$document_name), 'PHL', df$iso3)
 df$iso3 <- ifelse(grepl('Central African Republic', df$document_name), 'CAF', df$iso3)
 df$iso3 <- ifelse(grepl('République Centrafricaine', df$document_name), 'CAF', df$iso3)
 df$iso3 <- ifelse(grepl('Guinea', df$document_name), 'GIN', df$iso3)
 df$iso3 <- ifelse(grepl('Bénin', df$document_name), 'BEN', df$iso3)
 
 # crisis basis
 df$iso3 <- ifelse(grepl('Great Lakes', df$document_name), 'GREAT LAKES', df$iso3)
 df$iso3 <- ifelse(grepl('North Caucasus', df$document_name), 'NORTH CAUCASUS', df$iso3)
 df$iso3 <- ifelse(grepl('South Asia', df$document_name), 'SOUTH ASIA', df$iso3)
 df$iso3 <- ifelse(grepl('Indian Ocean', df$document_name), 'INDIAN OCEAN', df$iso3)
 df$iso3 <- ifelse(grepl('Horn', df$document_name), 'HORN', df$iso3)
 df$iso3 <- ifelse(grepl('Sahel', df$document_name), 'SAHEL', df$iso3)
 df$iso3 <- ifelse(grepl('West Africa', df$document_name), 'WEST AFRICA', df$iso3)
 df$iso3 <- ifelse(grepl('Southern African Region', df$document_name), 'SOUTHERN AFRICAN REGION', df$iso3)
 df$iso3 <- ifelse(grepl('Central Africa Region', df$document_name), 'CENTRAL AFRICAN REGION', df$iso3)
 
 
 return(df)
}   
appealsList <- addISO3(appealsList)
       
###################################################
###################################################
########### Encoding Time (from title) ############
###################################################
###################################################
# encoding the time of the appeals based on the cover title
encodeTime <- function(df = NULL) { 
 message('Encoding dates.\n')
 # returns only the dates strings (after the last comma)
 df$date <- gsub('(.+?),', "", df$document_name)
 
 # returns string w/o leading or trailing whitespace
 df$date <- gsub("^\\s+|\\s+$", "", df$date)
 
 # returns a date class
 df$date <- as.Date(df$date, format = "%d %b %Y")
 
 return(df)
}
appealsList <- encodeTime(appealsList)



###################################################
###################################################
################ Extracting Links #################
###################################################
###################################################
getLinks <- function() {
 message('Extracting document URLs for download.\n')
 base_url <- 'http://www.unocha.org/cap/appeals/by-appeal/results'
 page <- '?page='  # 492 appeals in 9 pages -- starts at 0.
 n_pages <- 9
 pb <- txtProgressBar(min = 0, max = n_pages, style = 3, char = ".")
 for(i in 0:n_pages) {
   setTxtProgressBar(pb, i)
   url <- paste0(base_url, page, i)
   doc <- htmlParse(url)
   # XPath to the PDF link only
   link_it <- data.frame(url =  xpathSApply(doc, '//*[@id="content-area"]/div/div[2]/div/div/div[1]/table/tbody/tr/td[2]/a[1]', xmlGetAttr, 'href'))
   if (i == 0) link_list <- link_it
   else link_list <- rbind(link_list, link_it)
 }
 
 # link_list[nchar(as.character(link_list$href)) > 4, ]
 # hrefs <- link_list[grepl(".pdf", link_list$hrefs) == T, ] # only pdf
 link_list$file_name <- sub('http://docs.unocha.org/sites/dms/CAP/', '', link_list$url)
 return(link_list)
}
message('Assembling a list of document URLs to be downloaded.')
link_list <- getLinks()

# merging final list with url and file names
appealsList <- cbind(appealsList, link_list)

# test by eye-balling that the merge is ok
# x <- appealsList[sample(nrow(appealsList), 5), ]

###################################################
###################################################
################# Sorting Output ##################
###################################################
###################################################
message('Writing CSV.\n')
write.csv(appealsList, paste(b_folder, 'data/appeals_list.csv', sep = ""), 
         row.names = F)
message('Done. Check the file /data/appeals_list.csv')