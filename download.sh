#!/bin/bash
Rscript code/download_appeals.R
zip -r data/folder.zip data/appeal_documents
mv data/folder.zip http/all_appeal_documents.zip
printf "\nCheck the folder data/appeals_documents for a complete list.\n\n"