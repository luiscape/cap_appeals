#!/bin/sh

# this script should be run from the
# code folder.
# cd code
# bash totxt.sh

# this script reads the PDF documents
# and extracts the text content
# into a TXT file

cd ../data/appeal_documents

# iterating over the pdf files
for f in *.pdf; do
        echo "creating report for: $f"
        pdftotext "$f"
done

# moving the resulting files to the txt_documents folder
cd ..
mkdir txt_documents
find ./appeal_documents -maxdepth 1 -name '*.txt' -exec mv {} txt_documents/ \;

# zipping results for sharing
zip -r txt_documents/All_Documents_in_TXT.zip txt_documents
mv txt_documents/All_Documents_in_TXT.zip ../http/All_Documents_in_TXT.zip