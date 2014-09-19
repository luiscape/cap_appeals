#!/bin/sh

# this script should be run from the
# code folder.
# cd code
# bash split.sh

# this script reads the PDF documents
# in the appeal_documents folder
# and splits them into single PDF documents
# for every page.
# it uses the name of the document as a
# reference when naming the new files.

cd ../data/appeal_documents
mkdir single_pages
for f in *.pdf; do
        echo "splitting: $f"
        filename="single_pages/${f%.*}"
        filename+="_page_%002d.pdf"
        pdftk "$f" burst output $filename
done