MyGitBackup - Back up your MySQL database using Git
===================================================

About
-----

MyGitBackup has been initially developed and released as Open Source by [Kodehuset AS](http://www.kodehuset.no)

MyGitBackup is a bash script which performs backup of MySQL databases and stores the backup in a Git repository. This provides an easy to use incremental backup using Git's efficient version control implementation. 

Contributing
------------

We appreciate any input on MyGitBackup, and any contribution through pull requests. 


Usage
-----

0. Deploy mygitbackup.sh to the server you want to run the backup from
0. Ensure the file is executable (chmod +x mygitbackup.sh)
0. Set up a new Git repository on your Git hosting service. If you don't currently have one, [Github](http://github.com) is a great service.
0. Clone the repository you want to use for backup to the server where you want to run the backup
0. Make sure there is no password or other input required in order to perform operations on the git repository. The preferred method is to use public key authentication and no passphrase on the private key.
0. Deploy your .mygitbackup configuration to the home folder of the user you are running the mygitbackup.sh script under, i.e. /home/backup_user/.mygitbackup
0. Run mygitbackup.sh


Configuration
-------------

Place a file on your home directory named ".mygitbackup" containing the following configuration: 

    ######################################
    # Configuration file for MyGitBackup #
    ######################################
        
    # Database configuration. Please provide the details below. 
    # Password is optional, in case you use key authentication to log on your MySQL instance.
    DATABASE_HOST="localhost"
    DATABASE_NAME="database name"
    DATABASE_USER="dbuser"
    #DATABASE_PASSWORD="optional"
    
    # Provide the path to where the backup repository is located. This needs to be checked out before running MyGitBackup for the first time.
    GIT_BACKUP_REPO="/path/to/backup-repo"
    
    # You can specify a custom name for the file used to backup the database and track changes. Default is "backup.sql". 
    # Uncomment the line below to specify your own name.
    #BACKUP_FILENAME="name_of_backup_file.sql"


Cron-job example
----------------

It may be preferable to set up a cron-job to prevent having to run the backup manually every time. Below is an example of such a cron job that runs a daily backup at midnight: 

    0 0 * * * /home/backupuser/mygitbackup/mygitbackup.sh



  