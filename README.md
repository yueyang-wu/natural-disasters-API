# NaturalDisasterAPI
## Intro
- This MySQL database is built for HappyHome web app https://github.com/yueyang-wu/HappyHome.
- It contains basic infomation and housing price of different counties in the U.S. as well as the details of natural disasters happened in the past 60 years.
- Check HappyHome.pdf for an UML diagram.

## Access database in local machine
- install and open MySQL server
- install and configure MySQL Workbench
- git clone this repo
- execute the queries in `HappyHome.sql` to create the database
- modify the absolute file path of the csv files in `HappyHomeInsert.sql`, then execute the queries to insert data
- check `HappyHomeSelect.sql` for sample select queries
