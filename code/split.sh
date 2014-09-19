#!/bin/sh
cd ../data/appeal_documents
mkdir single_pages
for f in *.pdf; do
        echo "splitting: $f"
        filename="single_pages/${f%.*}"
        filename+="_page_%002d.pdf"
        pdftk "$f" burst output $filename
done