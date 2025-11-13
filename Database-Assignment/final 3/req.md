Submit a complete MySQL Database dump of your database you will be using for your final project, with all tables, attributes, primary and foreign keys, and constraints implemented and created. Make sure there are at least 3 rows of sample data within each table. Ensure if you have made any changes to your Schema or ER Diagram since the last submission, you submit new versions of those as well as I will be grading the two against each other to ensure they match. 

Within your submission, include a document explaining your tables and how you are planning for user will interact with them. Give me examples of what a user will be doing in the front end to achieve this. My hope is this helps guide you into planning your user interface, if you see all backed SQL correlated to a fronted request that should be triggering it. Grouping similar queries into similar interface types will make life easier.

 

As a reminder, here is how we perform a database dump:

In a command prompt/terminal, navigate to the folder you would like your database dump .sql file to land
Run the following command: mysqldump -u username -p database_name > data-dump.sql
Your username should be "root"
Your database_name should be whatever you named your schema in MySQL
If you don't remember, open up a new query console in DataGrip for your localhost and run this command: SHOW DATABASES;
This will list all databases on your machine
You can optionally replace "data-dump.sql" with whatever you would like the database dump file to be called.