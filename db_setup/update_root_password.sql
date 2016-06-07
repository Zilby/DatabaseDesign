/****************************************************************
* Update the password for the root user (only necessary for Mac)
*****************************************************************/

UPDATE mysql.user
SET Password=PASSWORD("root")
WHERE User='root' AND Host='localhost';
