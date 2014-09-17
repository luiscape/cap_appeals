# text analysis of CAP documents
#Packages to Install
install.packages('tm')
install.packages('irlba')
install.packages('SnowballC')
install.packages('Matrix')
install.packages('wordcloud')

#Load In Packages
library(tm)
library(irlba)
library(SnowballC)
library(Matrix)
library(wordcloud)

######################################################
###Convert PDFs to Text and Read Text into a Data Object

#Set the Working Directory
setwd("C:/Users/nreinhart/Text Mining/UN Project/CAP")

#Create List of PDF Files
capDestination<-"./"
capLocalListPDF<-as.matrix(list.files(path = capDestination, pattern="pdf",full.names=TRUE))

#Convert PDF Files to Text
#Note:  You need to have pdftotext.exe from the XPDF program by Foo Labs
#Note: Additionally, I'll note that I think there's a way to do this step with tm package... but for the life of me I couldnt' figure it out.
message("Starting Conversion CAP PDFs to Text Files")
lapply(capLocalListPDF, function(i) system(paste('"C:/Users/nreinhart/Text Mining/UN Project/PDFtoTEXT/pdftotext.exe"',paste0('"', i, '"')), wait = FALSE) )
message("Finished Conversion CAP PDFs to Text Files")

#Create List of Text Documents
capLocalListTXT<-as.matrix(list.files(path = capDestination, pattern="txt",full.names=TRUE))

#Create Data Object to Hold All Text from All Documents
master<-matrix()
message("Starting Text Read and Input to Master")
for (i in 1:nrow(capLocalListTXT)){
master[i]<-paste(readLines(capLocalListTXT[i]),collapse=" ")
}
message("Finished Text Read and Input to Master")

#Write out CSV
#Note:  This is a functionally useless step.  Excel has character limits for cells, so this makes a 98MB useless csv.
write.csv(master,"./master.csv",sep=",")
######################################################
######################################################


######################################################
###Initial Text Mining Cleaning

#Convert Text Data Object to Corpus for tm package
capTM<-Corpus(VectorSource(master))

#Remove Extra White Space
#tm_map is the equivalent of the apply function but for Corpus objects.
capTM<-tm_map(capTM,stripWhitespace)

#Remove Punctuation
capTM<-tm_map(capTM,removePunctuation)

#Convert all characters to lower case
capTM<-tm_map(capTM,tolower)

#Remove numbers
capTM<-tm_map(capTM,removeNumbers)

#Remove stop words
capTM<-tm_map(capTM,removeWords,stopwords("english"))

#Stem the Words in the Document
capTM <- tm_map(capTM, stemDocument, "english")

#Reconvert to a PlainTextDocument
capTM <- tm_map(capTM, PlainTextDocument)

#Create Document Term Matrix
capTMdtm<-DocumentTermMatrix(capTM)

#Remove SparseTerms
capTMdtm<-removeSparseTerms(capTMdtm, 0.99)

#Find terms that appear at least 150 times
findFreqTerms(capTMdtm, 150)

#Need Step to Remove Other Not Useful Words
#Need Step to separate the French from the English Reports

#Find Words that have correlation of at least .01 with "affect"
findAssocs(capTMdtm, "affect", 0.1)
head(findAssocs(capTMdtm, "affect", 0.1),n=50L)

#print a wordcloud s
capTMdtmAsMatrix<-as.matrix(capTMdtm)
freqCapTMdtmAsMatrix<-as.matrix(colSums(capTMdtmAsMatrix))
sort.freqCapTMdtmAsMatrix<-as.matrix(sort(freqCapTMdtmAsMatrix, decreasing=TRUE))

sorted.capTMdtmAsMatrix<-sort(colSums(capTMdtmAsMatrix),decreasing=TRUE)
capNames<-names(sorted.capTMdtmAsMatrix)

color.list <- brewer.pal(8,"Dark2")
wordcloud(rownames(freqCapTMdtmAsMatrix), freqCapTMdtmAsMatrix[,1],min.freq=50,random.order=FALSE,colors=color.list)

png("./WordCloudProofOfConcept.png",width=7,height=7,units="in", res=1400)
wordcloud(rownames(freqCapTMdtmAsMatrix), freqCapTMdtmAsMatrix[,1],min.freq=50,random.order=FALSE,colors=color.list)
dev.off()
