#!/bin/bash

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups"

mkdir -p "$BACKUP_DIR"

docker exec hotel-booking-db sh -c \
'mysqldump --no-tablespaces -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
> "$BACKUP_DIR/hoteldb_$TIMESTAMP.sql"

echo "Backup completed successfully."
echo "Backup saved to $BACKUP_DIR/hoteldb_$TIMESTAMP.sql"