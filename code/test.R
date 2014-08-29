## testing scripts
message('There is 2 test here: ')
message('testCount() = tests if the counts are correct')
message('testDocuments() = tests if the number of files downloaded is correct')

# script that tests if the assembled list matches
# the counts at the top of the appeals website
testCount <- function(df = appealsList) {
  message('Performing tests:')
  # assembling test data
  url = 'http://www.unocha.org/cap/appeals/by-appeal/results?page=0'
  doc <- htmlParse(url)
  name =  xpathSApply(doc, '//*[@id="block-faceted_search_ui-3_guided"]/div/div/div/div/ul/li/span/a', xmlValue)
  count = xpathSApply(doc,'//*[@id="block-faceted_search_ui-3_guided"]/div/div/div/div/ul/li/span/span', xmlValue)
  count = sub("\\(", "", count)
  count = sub("\\)", "", count)
  count = as.numeric(sub("^\\s+", "", count))
  test_data <- data.frame(name, count)
  
  ## performing tests
  #  matching the assembled list with the count at the top of the page.
  df <- appealsList
  for (i in 1:nrow(test_data)) {
    n_scraped = nrow(df[df$appeal_type == as.character(test_data$name[i]), ])
    n_count = test_data$count[i]
    if (n_scraped != n_count) {
      message('------------------------------------')
      message(test_data$name[i], ': FAIL.')
      message('Reason: the number of appeals scraped seems to be wrong.')
      message('Scraped: ', n_scraped, " | Correct: ", n_count, " | Off by: ", n_scraped - n_count)
      message('------------------------------------')
    } else {
      message('------------------------------------')
      message(test_data$name[i], ': PASS.')
      message('------------------------------------')
    }
  }
}



# testing if all the documents were downloaded correctly.
testDocuments <- function(df = appealsList) {
  files_d <- list.files(paste(b_folder, 'data/appeal_documents/',sep = ""))
  if (nrow(appealsList) != nrow(files_d)) {
    message('Number of documents: FAIL.')
  } else message('Number of documents: PASS.')
}