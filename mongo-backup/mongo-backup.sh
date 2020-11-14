#!/bin/sh
set -e

#=====================================================================
# Configuration
#=====================================================================
# Database Name to backup
MONGO_DATABASE="my-db"
# Database host name
MONGO_HOST="127.0.0.1"
# Database port
MONGO_PORT="27017"
# Backup directory
BACKUPS_DIR="/home/$USER/Backups/Mongo/$MONGO_DATABASE"
# Database user name
DBUSERNAME="changeme"
# Database password
DBPASSWORD="changeme"
# Authentication database name
DBAUTHDB="admin"
# Days to keep the backup
DAYSTORETAINBACKUP="30"
#=====================================================================

TIMESTAMP=`date +%F-%H%M`
BACKUP_NAME="$MONGO_DATABASE-$TIMESTAMP"
ARCHIVE_PATH="$BACKUPS_DIR/$BACKUP_NAME.gz"

echo "$MONGO_DATABASE database backup started @ $TIMESTAMP"
echo "--------------------------------------------"

# Create backup directory
if ! mkdir -p $BACKUPS_DIR; then
  echo "Can't create backup directory in $BACKUPS_DIR. Please check and try again." 1>&2
  exit 1;
fi;

# Create dump
if ! mongodump --host $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE --username $DBUSERNAME --password $DBPASSWORD --authenticationDatabase $DBAUTHDB --authenticationMechanism "SCRAM-SHA-1" --forceTableScan --archive=$ARCHIVE_PATH --gzip; then
    echo "There was a problem dumping the database. Please check and try again." 1>&2
    exit 1;
fi;

# Delete backups older than retention period
find $BACKUPS_DIR -type f -mtime +$DAYSTORETAINBACKUP -exec rm {} +
echo "--------------------------------------------"
echo "$MONGO_DATABASE database backup completed @ $TIMESTAMP"
