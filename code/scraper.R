# Script to download all CAP appeals from the UNOCHA website.
# There are 492 appeals.

## HTML Structure
# views-table cols-3 table field
# views-field views-field-title table header

library(XML)
library(RCurl)
# res <- xpathApply(doc, "//table[@class='view view-appeals-by-appeal-view view-id-appeals_by_appeal_view view-display-id-default view-dom-id-1']", xmlValue)


downloadAppeals <- function(verbose = FALSE) {
    base_url <- 'http://www.unocha.org/cap/appeals/by-appeal/results'
    page <- '?page='  # 492 appeals in 11 pages -- starts at 0.
    
    message('Assembling a list of CAP documents.')
    pb <- txtProgressBar(min = 0, max = 6, style = 3)
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
    message('Assembling a list of Flash appeals documents.')
    if (verbose == TRUE) message(paste('Page:', i))
    pb <- txtProgressBar(min = 6, max = 8, style = 3)
    for(i in 6:8){
        setTxtProgressBar(pb, i)
        url <- paste0(base_url, page, i)
        if (i == 6) { 
            table <- getNodeSet(htmlParse(url),"//table")[[2]]
            doc <- readHTMLTable(table, useInternal = TRUE)
        }
        else { 
            doc <- readHTMLTable(getURL(url), useInternal = TRUE)
        }
        doc <- data.frame(doc[[1]])
        doc <- doc[1]
        colnames(doc)[1] <- 'Document Name'
        if (i == 6) flash_list <- doc
        else flash_list <- rbind(flash_list, doc)
    }
    names(flash_list) <- 'Document Name'
    flash_list$appeal_type <- 'Flash Appeal'
    
    # Other appeals from page 8 until page 9
    message('Assembling a list of other appeals documents.')
    pb <- txtProgressBar(min = 8, max = 9, style = 3)
    for(i in 8:9){
        if (verbose == TRUE) message(paste('Page:', i))
        setTxtProgressBar(pb, i)
        url <- paste0(base_url, page, i)
        if (i == 8) { 
            table <- getNodeSet(htmlParse(url),"//table")[[2]]
            doc <- readHTMLTable(table, useInternal = TRUE)
            doc <- doc[1]
        }
        else { 
            doc <- readHTMLTable(getURL(url), useInternal = TRUE)
            doc <- data.frame(doc[[1]])
            doc <- doc[1]
        }
        colnames(doc)[1] <- 'Document Name'
        if (i == 8) other_list <- doc
        else other_list <- rbind(other_list, doc)
    }
    names(other_list) <- 'Document Name'
    other_list$appeal_type <- 'Other appeals'
    x <<- other_list
    
    message('Done.')
    z_list <- rbind(cap_list, flash_list, other_list)
    return(z_list)
}

list <- downloadAppeals()


# writing CSV. 
write.csv(list, 'data/appeals_list.csv', row.names = F)
