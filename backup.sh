#!/bin/bash
set -e

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup directory
BACKUP_DIR="/backups"
mkdir -p "$BACKUP_DIR"

# Backup mounted volume
echo "Creating storage backup..."
cd /storage
tar czf "$BACKUP_DIR/storage_$TIMESTAMP.tar.gz" .

# Backup PostgreSQL database
echo "Creating database backup..."
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB | gzip > "$BACKUP_DIR/database_$TIMESTAMP.tar.gz"

# Upload to Azure Storage
echo "Uploading backups to Azure Storage..."
azcopy copy "$BACKUP_DIR/*_$TIMESTAMP.tar.gz" "$AZURE_STORAGE_CONNECTION_STRING/$AZURE_CONTAINER_NAME/"

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -type f -mtime +7 -name "*.tar.gz" -delete

echo "Backup completed successfully at $(date)"