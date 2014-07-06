# Script to download all CAP appeals from the UNOCHA website.
# There are 492 appeals.

## HTML Structure
# views-table cols-3 table field
# views-field views-field-title table header
# res <- xpathApply(doc, "//table[@class='view view-appeals-by-appeal-view view-id-appeals_by_appeal_view view-display-id-default view-dom-id-1']", xmlValue)
# links class: views-field views-field-field-dms-link-value

library(XML)
library(RCurl)
library(countrycode)


downloadAppeals <- function(verbose = FALSE) {
    base_url <- 'http://www.unocha.org/cap/appeals/by-appeal/results'
    page <- '?page='  # 492 appeals in 9 pages -- starts at 0.
    
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
        colnames(doc)[1] <- 'document_name'
        if (i == 0) cap_list <- doc
        else cap_list <- rbind(cap_list, doc)
    }
    names(cap_list) <- 'document_name'
    cap_list$id <- paste0('CAP-', 1:nrow(cap_list))
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
        colnames(doc)[1] <- 'document_name'
        if (i == 6) flash_list <- doc
        else flash_list <- rbind(flash_list, doc)
    }
    names(flash_list) <- 'document_name'
    flash_list$id <- paste0('FLA-', 1:nrow(flash_list))
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
        colnames(doc)[1] <- 'document_name'
        if (i == 8) other_list <- doc
        else other_list <- rbind(other_list, doc)
    }
    names(other_list) <- 'document_name'
    other_list$id <- paste0('OTH-', 1:nrow(other_list))
    other_list$appeal_type <- 'Other appeals'
    
    message('Done.')
    z_list <- rbind(cap_list, flash_list, other_list)
    return(z_list)
}

list <- downloadAppeals()

# Adding iso3 codes; around 50 don't encode.
list$iso3 <- countrycode(list$document_name, 'country.name', 'iso3c')


encodeTime <- function(df = NULL) { 
    # returns only the dates strings (after the last comma)
    df$date <- gsub('(.+?),', "", df$document_name)
    
    # returns string w/o leading or trailing whitespace
    df$date <- gsub("^\\s+|\\s+$", "", df$date)
    
    # returns a date class
    df$date <- as.Date(df$date, format = "%d %b %Y")
    
    return(df)
}
list <- encodeTime(list)

# writing CSV. 
write.csv(list, 'data/appeals_list.csv', row.names = F)


#### Extracting Links  ####
getLinks <- function() {
    pb <- txtProgressBar(min = 0, max = 9, style = 3)
    for(i in 0:9) {
        setTxtProgressBar(pb, i)
        url <- paste0(base_url, page, i)
        doc <- htmlParse(url)
        link_it <- data.frame(hrefs =  xpathSApply(doc, '//*[@class="views-field views-field-field-dms-link-value"]/a',xmlGetAttr, 'href'))
        if (i == 0) link_list <- link_it
        else link_list <- rbind(link_list, link_it)
    }
    return(link_list)
}

link_list <- getLinks()

# writing CSV. 
write.csv(link_list, 'data/appeals_list.csv', row.names = F)
