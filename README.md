# Personal expenses tracking system

## Introduction

In this project, I developed a MySQL database called credit_card tracking all of my credit card expense since March 2022 . This includes ONLY the purcheses made with my only credit card. These expenses are extracted from my credit card website "Isracard" in the form of CSV files, transformed using customized Python scripts, and loaded into the database via the SQLAlchemy Python library. I then created SQL queries to understand my spending habits and developed a Tableau dashboard linked to the database to view these insigths visually.

## Technologies and Skills

Technologies: SQL (MySQL), Dbeaver database manger, Python (Pandas, OS, SQLAlchemy), Tableau.
Skills: Data modeling, database development, data cleaning, data analysis, data visualization/dashboarding

## Inspiration

The inspiration for my first data analysis/engineering project stemmed from the understanig the importance of data in today industry. Witnessing the transformative power of data-driven insights in various fields, from healthcare to finance, ignited my curiosity to explore the boundless possibilities of harnessing data. 

## ER diagram

Since it's my first project, for simpliciaty the database consist of only two tables, 'expenses' that containg only the needed data for the analysis such as date of transaction, name of the buisness, and the amount of the transaction. the other table catagorize each buisness name to spending catagory such as  bills, education etc...

![צילום מסך 2024-05-14 ב-22 47 36](https://github.com/roni45455/Personal-finance-project/assets/160248285/3cef1385-9810-47a2-bf36-00e63673adc2)
## Data cleaning, database creation and data loading

My data was exported from the credit card company website as Excel files and stored in a local directory called "Raw data":
[Example](https://github.com/roni45455/Personal-finance-project/blob/main/input_file_example.xls) for "Raw data CSV file".

Using Python's Pandas library, I created a function that loads the Excel file to Pandas Dataframe and remove irellevant data, renames column names from Hebrew to English and modifies the data types for easier analysis.
Every file that was cleaned was appended to one main dataframe (later to be imported to the databse as the "expense" table,
The function iterated througth all files in the "Raw data" directory).
[Example](https://github.com/roni45455/Personal-finance-project/blob/main/clean_file_example.csv) for "clean CSV data file"

Using SQLalchemy library, I created a connection with the local MySql DBMS and imported the main dataframe as the expense table to the database.

Link for the [ETL Python script](https://github.com/roni45455/Personal-finance-project/blob/main/ETL.ipynb)

## SQL Analysis 
One I have set up my database with the expenses table, I created another table (in the same database) called "Catagory" which its porpuse is to catagorize the name of the buisness to certien catagory (Bills, Transport, Education etc...).
The following queries are used to expore the data and extract usful insigths regarding financial spending habits, detection anomalities and creating an overview.
The whole datadase is created in a way that it can de easliey updated with new data, link for the [SQL queries](https://github.com/roni45455/Personal-finance-project/blob/main/Queries.sql)







