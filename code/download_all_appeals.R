# Script to download all CAP appeals from the UNOCHA website.
# There are 492 appeals.

## HTML Structure
# views-table cols-3 table field
# views-field views-field-title table header

library(XML)
library(RCurl)
res <- xpathApply(doc, "//table[@class='view view-appeals-by-appeal-view view-id-appeals_by_appeal_view view-display-id-default view-dom-id-1']", xmlValue)


downloadCAPs <- function(verbose = FALSE) {
    message('Assembling a list of CAP documents.')
    message('Downloading CAP documents.')
    pb <- txtProgressBar(min = 0, max = 6, style = 3)
	base_url <- 'http://www.unocha.org/cap/appeals/by-appeal/results'
	page <- '?page='  # 492 appeals in 11 pages -- starts at 0.
    # CAP appeals go until page 6
    for(i in 0:6) {
        if (verbose == TRUE) message(paste('Page:', i))
        setTxtProgressBar(pb, i)
        url <- paste0(base_url, page, i)
        doc <- readHTMLTable(getURL(url), useInternal = TRUE)
        doc <- data.frame(doc)
        doc <- doc[1]
        colnames(doc)[1] <- 'Document Name'
        if (i == 0) cap_list <- doc
        else cap_list <- rbind(cap_list, doc)
    }
    names(cap_list) <- 'Document Name'
    cap_list$appeal_type <- 'Consolidated Appeal'
    
    # Flash appeals from page 6 until page 8
    message('Downloading Flash appeals documents.')
    pb <- txtProgressBar(min = 6, max = 8, style = 3)
    for(i in 6:8){
        setTxtProgressBar(pb, i)
    }
    
    # Other appeals from page 8 until page 9
    message('Downloading other appeals documents.')
    pb <- txtProgressBar(min = 6, max = 8, style = 3)
    for(i in 6:8){
        setTxtProgressBar(pb, i)
    }
    
    message('Done.')
    return(list)
}

x <- downloadCAPs()