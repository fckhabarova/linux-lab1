
#!/bin/bash
COUNT=$(find "$HOME" -type d -path '*/.*' -prune -o -type f -newermt "$(date +%Y-%m-%d)" -print | wc -l)
echo "Количество файлов в домашнем каталоге, созданных или измененных сегодня: $COUNT"

