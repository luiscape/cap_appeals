#!/bin/sh
for f in *.pdf; do
        echo -n "$f"
        pdfinfo "$f" 2>/dev/null | grep Creator | cut -d ":" -f 2
done