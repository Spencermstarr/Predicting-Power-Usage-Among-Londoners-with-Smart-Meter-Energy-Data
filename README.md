# Predicting-Power-Usage-Among-Londoners-with-Smart-Meter-Energy-Data
We analyzed the effects of an experimental time-of-use electricity pricing scheme the municipal government of London imposed in order to try to reduce London's overall Greenhouse Gas Emissions. 

# Course CS504 this project was conducted for - Principles of Data Management and Mining
# University Program Context - Students Pursuing a Master's in Data Analytics Engineering at George Mason University

A moderately deep, nevertheless, wide dive into the world of RDBMS, NoSQL and distributed filesystems. 

## Files from Sprint 0-8 

The doc and ppt files are from the team's weekly Sprint with our Prof who plays the role of our customer. 

## MySQL database creation SQL scripts

The SQL script files contains lots of basic statements we use to create and populate all tables, to check our results, apply DML, DDL and build indexes where we deemed necessary to boost query performance 

## MySQL database backup restore process

Download the files with extension .zip.00x where x=1,2,3,4 .
One way to do that is by following the directions from  https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository

If that's complicated, then do as follows: 
To download from our GitHub site click on the green "Code" download button, visible on the upper right of the proj's page and download a ZIP file that contains the entire repository. 

Then download and install 7-zip utility from https://www.7-zip.org/download.html  on your machine by selecting either of the top 2 choices under 
**Download 7-Zip 19.00 (2019-02-21) for Windows**
 
Then extract the contents of the 7-zip archive (split in the three .zip.00x files) by right clicking on .zip.001 file, then select 7-zip and, finally, by selecting "extract  files" to point wherever you prefer to save the extracted contents on your local filesystem. 

The decompressed file should be a file with a .sql extension. That's a backup of the MySQL database with all the Kaggle site data, indexes, stored procs written to load the data and anything else that comes with them. 

Create a database named SMIL and a user named stavros on the localhost with granted privileges in order to restore the database.

To restore the database backup, you'll need to run a restore MySQL command as shown at https://phoenixnap.com/kb/how-to-backup-restore-a-mysql-database
You can restore the backup of MySQL database on the VBox VM you already installed for the HWork, or on any other machine you prefer. 

## ERD
It was built in LucidChart following crow-foot notation

## Authors

Team Carbon, based on the element humanity is made of.

## Acknowledgments

* Do not use the database generation SQL scripts as a monolithic block, study them before pick and choose whatever is convenient or educational for you to test and run.
* We work hard to complete this Agile/Scrum exercise successfully.  
