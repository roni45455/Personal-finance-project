# Personal expenses tracking system
Note that the projects is still being worked on and the files are constantly being updated

## Introduction

In this project, I developed a MySQL database called credit_card tracking all of my credit card expense since March 2022 . This includes ONLY the purcheses made with my only credit card. These expenses are extracted from my credit card website "Isracard" in the form of CSV files, transformed using customized Python scripts, and loaded into the database via the SQLAlchemy Python library. I then created SQL queries to understand my spending habits and developed a Tableau dashboard linked to the database to view these insigths visually.

## Technologies and Skills

Technologies: SQL (MySQL), Dbeaver database manger, Python (Pandas, OS, SQLAlchemy), Tableau.
Skills: Data modeling, database development, data cleaning, data analysis, data visualization/dashboarding

## Data cleaning, database creation and data loading

My data was exported from the credit card company website as Excel files and stored in a local directory called "Raw data", this is an example for a raw data file:
![]


## SQL Analysis 
One I have set up my database with the expenses table, I created another table (in the same database) called "Catagory" which its porpuse is to catagorize the name of the buisness to certien catagory (Bills, Transport, Education etc...).
The following queries are used to expore the data and extract usful insigths regarding financial spending habits, detection anomalities and creating an overview.
The whole datadase is created in a way that it can de easliey updated with new data, link for the [SQL queries](https://github.com/roni45455/Personal-finance-project/blob/main/Queries.sql)

## Visualization with Tableau

In addition, I wanted a visual representation of my spending habits. I chose to create a Tableau dashboard for this purpose. I imported all the tables from the credit_card database. 
(Note : I could not link the interactive dashboard since I dont hold Tableu paid membership)
![צילום מסך 2024-05-15 ב-0 40 56](https://github.com/roni45455/Personal-finance-project/assets/160248285/fc23e90d-28e6-45d5-8dff-6614f7f091ca)








