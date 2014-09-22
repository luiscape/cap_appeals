## This downloads the CAP appeals input from Google Spreadsheet
## and stores in the http folder for the creation of a quick dashboard

# library dependencies
library(XML)
library(RCurl)
 
# code dependencies
source('code/write_tables.R')  # for writing dbs in ScraperWiki

# function that scrapes the sheets that have the data input per researcher
scrapeList <- function(url) {
  cat('-------------------------------\n')
  cat('Assembling a list of inputs.\n')
  cat('-------------------------------\n')
  
  # getting the doc
  doc <- htmlParse(getURL(url))
  
  # creating a list of names
  xpathList = c(
    '//*[@id="sheet-button-904427038"]/a', 
    '//*[@id="sheet-button-1351793353"]/a', 
    '//*[@id="sheet-button-1203559118"]/a')
  
  for (i in 1:length(xpathList)) {
    itRes <- data.frame(
      name = xpathSApply(doc, xpathList[i], xmlValue)
    )
    if (i == 1) resList <- itRes
    else resList <- rbind(resList, itRes)
  }
  
  # adding ids
  resList$id <- c('904427038', '1351793353', '1203559118')
  
  # iterating over values
  for (i in 1:length(resList)) {    
    
    it <- data.frame(
      docID =  xpathSApply(doc, paste("//*[@id='", resList$id[i],"']/div/table/tbody/tr/td[1]", sep=""), xmlValue),
      indicator_name = xpathSApply(doc, paste("//*[@id='", resList$id[i],"']/div/table/tbody/tr/td[2]", sep=""), xmlValue),
      indicator_value = xpathSApply(doc, paste("//*[@id='", resList$id[i],"']/div/table/tbody/tr/td[3]", sep=""), xmlValue),
      page_number = xpathSApply(doc, paste("//*[@id='", resList$id[i],"']/div/table/tbody/tr/td[4]", sep=""), xmlValue),
      comment = xpathSApply(doc, paste("//*[@id='", resList$id[i],"']/div/table/tbody/tr/td[5]", sep=""), xmlValue)
    )
    
    # cleaning the first row
    it = it[-1,]
    
    # cleaning the commas
    it$indicator_value <- gsub(",", "", it$indicator_value)
    
    # adding researcher name
    if (nrow(it) > 1) {
      # right now Luis has nothing
      it$researcher <- resList$name[i]  
    }
    
    # cleaning white space (everywhere!)
    
    # assembling a single data.frame
    if (i == 1) output <- it
    else output <- rbind(output, it)
  }
  
  # return data.frame
  cat('-------------------------------\n')
  cat('Done.\n')
  cat('-------------------------------\n')
  return(output)
   
}

# running
inputData <- scrapeList('https://docs.google.com/spreadsheets/d/1KWH0kGkCt8RrGBReqE3LgMJBFofNA_n_tNimkAISJHc/pubhtml#')

# storing csv
write.csv(inputData, 'http/inputData.csv', row.names = F)

# writing tables
writeTables(inputData, 'inputData', 'scraperwiki')
