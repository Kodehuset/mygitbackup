#!/bin/bash
SCRIPT_NAME="MyGitBackup"
SCRIPT_VERSION="Alpha 1" 
echo "$SCRIPT_NAME v. $SCRIPT_VERSION"

BACKUP_FILENAME="backup.sql"

# Load user configuration
if [ ! -f ~/.mygitbackup ] 
	then
	echo "ERROR: Unable to locate configuration parameters. Please configure $SCRIPT_NAME via ~/.mygitbackup"
	exit 0
fi

source ~/.mygitbackup

echo "Checking..." 

if [ ! $DATABASE_HOST ] || [ ! $DATABASE_NAME ] || [ ! $DATABASE_USER ] 
	then
	echo "Please provide the required DATABASE_HOST, DATABASE_NAME and DATABASE_USER variables."
	exit 0
fi

if [ ! $GIT_BACKUP_REPO ]
	then
	echo "Please provide the location of the Git backup repo on this box by configuring the GIT_BACKUP_REPO variable."
	exit 0
fi

if [ ! -d $GIT_BACKUP_REPO ]
	then
	echo "Unable to locate the folder $GIT_BACKUP_REPO. Are you sure the backup repo has been cloned to this box?"
	exit 0
fi

MYSQL_DUMP=$(which mysqldump)
if [ ! $MYSQL_DUMP ] || [ ! -f $MYSQL_DUMP ] 
	then
	echo "Unable to locate mysqldump. Are you sure you have installed MySQL on this box?"
	exit 0
fi

echo "Found MySQL Dump at $MYSQL_DUMP"

GIT=$(which git)
if [ ! $GIT ] || [ ! -f $GIT ] 
	then
	echo "Unable to locate Git. Are you sure you have installed Git on this box?"
	exit 0
fi

echo "Found Git at $GIT"

cd "$(dirname "$GIT_BACKUP_REPO/.")"

MYSQL_DUMP_OPTIONS="--skip-extended-insert --compact"
echo "Performing MySQL dump of $DATABASE_HOST/$DATABASE_NAME"
if [ ! -z $DATABASE_PASSWORD ] 
	then

	$MYSQL_DUMP $MYSQL_DUMP_OPTIONS -u$DATABASE_USER -p$DATABASE_PASSWORD -h$DATABASE_HOST $DATABASE_NAME > $BACKUP_FILENAME
	
else 

	$MYSQL_DUMP $MYSQL_DUMP_OPTIONS -u$DATABASE_USER -h$DATABASE_HOST $DATABASE_NAME > $BACKUP_FILENAME

fi

if [ ! $? = 0 ] 
	then
	echo "MySQL Dump terminated with an unexpected result. Please investigate the errors which should be printed above and try again."
	exit 0
fi

echo "Database dump completed. Committing..."
$GIT add backup.sql
$GIT commit -m "New database backup."
$GIT push

echo "All done."
