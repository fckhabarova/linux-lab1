#!/bin/bash

LOG_FILE="/var/log/khabarova.log"

if [ -n "$1" ] && [ -n "$2" ]; then
    TARGET_DIR="$1"
    SIZE_MB="$2"
    echo "Command line arguments are used: catalog '$TARGET_DIR', size ${SIZE_MB}MB"
else
    read -p "Enter the path to the directory: " TARGET_DIR
    read -p "Enter the size N in megabytes: " SIZE_MB
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: The catalog '$TARGET_DIR' does not exist." | sudo tee -a "$LOG_FILE"
    exit 1
fi

if ! [[ "$SIZE_MB" =~ ^[0-9]+$ ]]; then
    echo "Error: The size '$SIZE_MB' is not a number." | sudo tee -a "$LOG_FILE"
    exit 1
fi

SIZE_ARG="+${SIZE_MB}M"

echo "Size search in '$TARGET_DIR' larger size ${SIZE_MB}MB..."

sudo find "$TARGET_DIR" -type f -size "$SIZE_ARG" -print0 | while IFS= read -r -d '' file; do
    # Пропускаем файлы, которые уже являются .gz архивами
    if [[ "$file" == *.gz ]]; then
        echo "--- Skipping: $file (already .gz) ---" | sudo tee -a "$LOG_FILE"
        continue
    fi

    echo "--- Processing: $file ---" | sudo tee -a "$LOG_FILE"

    if sudo gzip -f "$file"; then
        echo "Archive created: ${file}.gz" | sudo tee -a "$LOG_FILE"
    else
        echo "ERROR: Failed to pack $file" | sudo tee -a "$LOG_FILE"
        continue
    fi

    sudo rm -f "$file"
    echo "The original file is deleted." | sudo tee -a "$LOG_FILE"

    sudo touch "$file"
    echo "Empty file has been created: $file" | sudo tee -a "$LOG_FILE"
    echo "---------------" | sudo tee -a "$LOG_FILE"
done

echo "The script is complete. The log is saved in $LOG_FILE"
