FROM debian:12-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    postgresql-client \
    curl \
    cron \
    gzip \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install azcopy
RUN curl -L https://aka.ms/downloadazcopy-v10-linux | tar -xz --strip-components=1 -C /usr/local/bin && \
    chmod +x /usr/local/bin/azcopy

# Create backup directory
RUN mkdir -p /backups /storage

# Create directory for cron logs
RUN mkdir -p /var/log/cron && \
    touch /var/log/cron.log

# Copy backup script
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Setup cron job
COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron && \
    crontab /etc/cron.d/backup-cron

# Start cron in foreground
CMD ["cron", "-f"]