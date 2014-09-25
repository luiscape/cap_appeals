#!/bin/sh

# this script should be run from the
# code folder.
# cd code
# bash totxt.sh

# this script reads the PDF documents
# and extracts the text content
# into a TXT file

cd ../data/appeal_documents
mkdir txt_documents
for f in *.pdf; do
        echo "creating report for: $f"
        filename="txt_documents/${f%.*}"
        filename+="report.txt"
        pdftk "$f" dump_data output $filename
done