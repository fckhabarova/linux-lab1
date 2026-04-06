#!/bin/bash

TODAY=$(date +%Y-%m-%d)
COUNT=0

for file in /home/fckhabarova/*; do
    if [ -f "$file" ] && [ "$(date -r "$file" +%Y-%m-%d)" = "$TODAY" ]; then
        COUNT=$((COUNT + 1))
    fi
done

echo "Count : $COUNT"
