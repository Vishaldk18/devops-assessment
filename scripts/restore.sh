#!/bin/bash

set -e

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: ./scripts/restore.sh <backup-file.sql>"
    exit 1
fi

docker exec -i hotel-booking-db sh -c \
'mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
< "$BACKUP_FILE"

echo "Database restored successfully."