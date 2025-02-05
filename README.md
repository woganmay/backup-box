Backup Container
================

This project ships a buildable backup container designed for Laravel projects, ie:

* It can mount to a storage volume to export it
* It can run postgresql backups
* Files are uploaded to a configured Azure Storage Container on a schedule
* Backups can be invoked manually by getting a commandline on the container and running ./backup.sh

# Using in a project
To install this container, add it as a docker-compose service with the following sample config:

    services:
      backup:
        image: ghcr.io/woganmay/backup-box:latest
        volumes:
          - storage-data:/storage
          - backup-data:/backups
        environment:
          - POSTGRES_HOST=db
          - POSTGRES_DB=your_database
          - POSTGRES_USER=your_user
          - POSTGRES_PASSWORD=your_password
          - AZURE_STORAGE_ACCOUNT=your_account_name
          - AZURE_CONTAINER_NAME=your_container_name
          - AZURE_STORAGE_SAS_TOKEN=your_sas_token
        depends_on:
          - db

    volumes:
      storage-data:
        external: true
      backup-data:

When booted, it will automatically run the contents of backup.sh per the schedule in the crontab file.
