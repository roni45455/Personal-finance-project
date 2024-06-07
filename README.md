# Personal expenses tracking system
Note that the projects is still being worked on and the files are constantly being updated

## Introduction

In this project, I developed a MySQL database called credit_card tracking all of my credit card expense since March 2022 . This includes ONLY the purcheses made with my only credit card. These expenses are extracted from my credit card website "Isracard" in the form of CSV files, transformed using customized Python scripts, and loaded into the database via the SQLAlchemy Python library. I then created SQL queries to understand my spending habits and developed a Tableau dashboard linked to the database to view these insigths visually.

## Technologies and Skills

Technologies: SQL (MySQL), Dbeaver database manger, Python (Pandas, OS, SQLAlchemy), Tableau.
Skills: Data modeling, database development, data cleaning, data analysis, data visualization/dashboarding

## Data cleaning, database creation and data loading

My data was exported from the credit card company website as Excel files and stored in a local directory called "Raw data", this is an example for a raw data file:

<img width="590" alt="צילום מסך 2024-06-07 ב-22 25 35" src="https://github.com/roni45455/Personal-finance-project/assets/160248285/ae553243-1152-4ee3-a338-805b606d1df6">

The following script is using pandas to create one main Dataframe from all the clean CSV files and loads it into the MySQL server.

First we import the relevent libraries:
```python
import pandas as pd
from sqlalchemy import create_engine
import os
```
The following function effectively cleans up the Excel data by removing unnecessary columns, renaming columns, and reformatting the DataFrame before saving it to a new CSV file:
```python
def clean(file_path,new_file_name):
    df = pd.read_excel(file_path,header = 5)
    cut_index = df[df['תאריך רכישה']== 'תאריך רכישה'].index[0]
    part1 = df[:cut_index-2]
    part1 = part1.drop(columns = ['מספר שובר','פירוט נוסף'])
    new_header = df.iloc[cut_index] 
    part2 = df[cut_index+1:]  
    part2.columns = new_header
    part2 = part2.drop(columns = 'תאריך חיוב')
    part2 = part2.dropna(axis=1,how='all')
    part2 = part2.dropna()
    part2 = part2.rename(columns={'סכום מקורי': 'סכום עסקה'})
    new_df = pd.concat([part1,part2])
    new_df = new_df.drop(columns=['מטבע מקור','סכום חיוב','מטבע לחיוב'])
    new_df.to_csv(new_file_name,encoding='utf-8-sig',index=False)
```
The clean file looks like this:

<img width="258" alt="צילום מסך 2024-06-07 ב-22 26 24" src="https://github.com/roni45455/Personal-finance-project/assets/160248285/5d386907-c549-452e-bbc4-c29db8ac41d8">

This loop iterates through all files with a ".xls" extension in the specified directory, applies the clean function to each file, and saves the cleaned data as CSV files.
By running this loop, each Excel file in the directory will be cleaned and saved as a corresponding CSV file using the clean function.
```python
directory = '/Users/ronipinus/Desktop/VS-Workspace/ project/raw data'
for file in os.listdir(directory):
    if file.endswith('.xls'):
        file_path = os.path.join(directory,file)
        new_name = file.split('.')
        new_file_name = os.path.join(directory,new_name[0][7:]+'.csv')
        clean(file_path,new_file_name)
```

This reads multiple CSV files from a directory, combines them into a single DataFrame, and then renames columns of the combined DataFrame.
This effectively combines multiple CSV files into a single DataFrame and standardizes the column names for further analysis or processing.
```python
directory = '/Users/ronipinus/Desktop/VS-Workspace/ project/clean data'
df_list = []
for file in os.listdir(directory):
     if file.endswith(".csv"):
        file_path = os.path.join(directory, file)
        df = pd.read_csv(file_path)
        df_list.append(df)
main_df = pd.concat(df_list, ignore_index=True)
main_df.rename(columns={'תאריך רכישה': 'date' , 'שם בית עסק': 'name' , 'סכום עסקה': 'amount'} , inplace=True)
```

The following creates a connection engine to a MySQL database named "credit_card".
create_engine is a function from the SQLAlchemy library used to create a connection engine to a database.
the parameter of the function are:
'mysql+pymysql://': This part specifies the database dialect (mysql) and the driver (pymysql) to be used for connecting to the MySQL database.
'root:password@localhost': This part specifies the username (root) and password (password) for connecting to the MySQL server running on localhost.
'credit_card': This is the name of the MySQL database to which we want to connect.
```python
conn = create_engine('mysql+pymysql://root:password@localhost/credit_card')
```
The last step is to write the DataFrame main_df to a SQL database table named 'expenses'.
```python
main_df.to_sql('expenses', conn, if_exists='replace',index=False)
```


## SQL Analysis 
Once I have set up my database with the expenses table, I created another table (in the same database) called "Catagory" which its porpuse is to catagorize the name of the buisness to certien catagory (Bills, Transport, Education etc...).
```sql
---------------------------------------------------------------------
-- This query allows constantly update and catogorize new expenses --
---------------------------------------------------------------------
UPDATE credit_card.catagory
SET catagory =
    CASE
        WHEN name REGEXP 'מי שבע|חשמל|ביטוח לאומי|פרי טיוי|FREETV|HOT|עיריית|אמישראגז|מאוחדת' THEN 'Bills'
        
        WHEN name REGEXP 'סופרמרקט|מרקט|קשת טעמים|מרכז המזון|דליקטס|עוף תקתוק|רמי לוי|האופה|בשר|בעיר|ממתקי|הפרי והירק|מעיין|המאפייה|סופר קלאב|מינימרקט סולי|שופרסל|דבאח|מאפית|סופר אלונית -אלון מע|טעם טוב|סופר קופיקס|מיני סופר|להב|פאפא גונס|קיוסק|סופר יעלים|מינמירקט סולי|פיצוצית אורן|תענוג ב|THE GROCERY STORE|גרעיני עפולה' THEN 'Groceries'
        
        WHEN name REGEXP 'הדרומית| המקסיקני|בוזה|בנדורה|סנדביץ|כנאפה|פיצה|מקדונלדס|צוקה באר שבע|דוברין|300 גרם|אגאדיר|שווארמה|בורגר|משלוחה|רובן|קריספי|מפגש מתן נועם|חומוס|איקאה מסעדה ב"ש|המשמח|בית הפול|סומבררו|מאפה נאמן|EL CAFFE ROSA|בית העגל|בי בי בי|פלאפל|המקסיקני אב"ג בע"מ|אבולעפיה|גיגסי|כנפת אלקרם|הספריה|מצדה 31|WOLT|KFC|בית הלחם|איסקרים|מנצס|קפה|ברוסקטה|קמפאי|שייק|JAPANIKA|שיפודי|מסעדת|השמן|שוקולטה|סטקית|פיצה' THEN 'Resturants'
        
        WHEN name REGEXP 'יס פלאנט| שרונה|קווינס|מרכז קנדה|AMAZON VIDEO 344M61X|יהודה|מובילנד|החרושת 11|DESERT|ברקה|גטאין|שמה שמה|זאפה|טיקטס|בלנדר|בר|פורום|ברדק|נייטס|איוונטר|ברים|גיימס|רוזה' THEN 'Entertainment'
        
        WHEN name REGEXP 'יפה נוף תחבורה תשתיו|סונול|מ.תחבורה ר.נהיגה|דור אלון|חוצה צפון|אגד|פנגו|WIND|KORKIFIX|YANGO|GETT|פז|רב קו|EGED|רכבת ישראל|כביש|דרך ארץ - 6 אישי|דלק' THEN 'Transportation'
        
        ELSE 'Other'
    END;
 
---------------------------------------------------
-- check for new expense for possible catagorize --
---------------------------------------------------
SELECT * FROM credit_card.catagory c WHERE c.catagory  = 'Other' 
```
And from here we can run some queries for overall insights:
```sql
 ------------------------------------
   -- Monthly  overall expanses view --
   ------------------------------------
   CREATE OR REPLACE VIEW Months as
   SELECT 
   		YEAR(e.`date`) as 'Year',
   		MONTHNAME(e.`date`) as 'Month', 
   		ROUND(SUM(e.amount))  as 'Total'
   FROM credit_card.expenses e 
   GROUP BY MONTHNAME(e.`date`),YEAR(e.`date`)
   ORDER BY MIN(e.`date`);
  
  SELECT * from Months 
  
  ------------------------------------------------------------------------------
  -- Compare monthly expense (of certin month) to same month of previous years --
  ------------------------------------------------------------------------------
  SELECT 
    Year,
    Month,
    Total,
    Total - LAG(Total) OVER (ORDER BY Year) AS Diff_from_last_year
  FROM Months
  WHERE Month = 'March'; 

  ---------------------------------
  -- monthly avrage for each year--
  ---------------------------------
  SELECT `Year`, round(AVG(Total),2) as `average_monthly_sum`
  FROM Months 
  GROUP BY `Year`;
```
I also wanted to determine monthly budget for each catagory based on the expenses data I hold.
Since I'm handaling relativly small amount of data, anomalities or "spikes" in monthly expenses can Significantly impact the monthly avrage, I used the k-th percentile to determin the monthly budget for each catagory.
```sql
CREATE TABLE credit_card.budget(
 catagory VARCHAR(50),
 Budget INT
 );

------------------------------------------------------
-- Calculate 75th percentile of Bills for budgeting -- 
------------------------------------------------------
INSERT INTO credit_card.budget (catagory,Budget)
WITH bills AS (
    SELECT 
        YEAR(e.`date`) AS Year,
        MONTHNAME(e.`date`) AS Month, 
        ROUND(SUM(e.amount)) AS total,
        ROW_NUMBER() OVER (ORDER BY ROUND(SUM(e.amount))) AS row_num
    FROM credit_card.expenses e 
    JOIN credit_card.catagory c ON e.name = c.name
    WHERE c.catagory = 'Bills'
    GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT 'Bills', FLOOR(total/100)*100
FROM bills
WHERE row_num = FLOOR((75/100.0) * (SELECT COUNT(*) FROM bills));

----------------------------------------------------------
-- Calculate 50th percentile of Groceries for budgeting -- 
----------------------------------------------------------
INSERT INTO credit_card.budget (catagory,Budget)
WITH groceries AS (
    SELECT 
        YEAR(e.`date`) AS Year,
        MONTHNAME(e.`date`) AS Month, 
        ROUND(SUM(e.amount)) AS total,
        ROW_NUMBER() OVER (ORDER BY ROUND(SUM(e.amount))) AS row_num
    FROM credit_card.expenses e 
    JOIN credit_card.catagory c ON e.name = c.name
    WHERE c.catagory = 'Groceries'
    GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT 'Groceries', FLOOR(total/100)*100
FROM Groceries
WHERE row_num = FLOOR((50/100.0) * (SELECT COUNT(*) FROM groceries));

----------------------------------------------------------
-- Calculate 50th percentile of Resturants for budgeting -- 
----------------------------------------------------------
INSERT INTO credit_card.budget (catagory,Budget)
WITH Resturants AS (
    SELECT 
        YEAR(e.`date`) AS Year,
        MONTHNAME(e.`date`) AS Month, 
        ROUND(SUM(e.amount)) AS total,
        ROW_NUMBER() OVER (ORDER BY ROUND(SUM(e.amount))) AS row_num
    FROM credit_card.expenses e 
    JOIN credit_card.catagory c ON e.name = c.name
    WHERE c.catagory = 'Resturants'
    GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT 'Resturants', FLOOR(total/100)*100
FROM Resturants
WHERE row_num = FLOOR((50/100.0) * (SELECT COUNT(*) FROM Resturants));

----------------------------------------------------------
-- Calculate 40th percentile of Entertainment for budgeting -- 
----------------------------------------------------------
INSERT INTO credit_card.budget (catagory,Budget)
WITH Entertainment AS (
    SELECT 
        YEAR(e.`date`) AS Year,
        MONTHNAME(e.`date`) AS Month, 
        ROUND(SUM(e.amount)) AS total,
        ROW_NUMBER() OVER (ORDER BY ROUND(SUM(e.amount))) AS row_num
    FROM credit_card.expenses e 
    JOIN credit_card.catagory c ON e.name = c.name
    WHERE c.catagory = 'Entertainment'
    GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT 'Entertainment', FLOOR(total/100)*100
FROM Entertainment
WHERE row_num = FLOOR((40/100.0) * (SELECT COUNT(*) FROM Entertainment));

----------------------------------------------------------
-- Calculate 50th percentile of Transportation expenses -- 
----------------------------------------------------------
INSERT INTO credit_card.budget (catagory,Budget)
WITH Transportation AS (
    SELECT 
        YEAR(e.`date`) AS Year,
        MONTHNAME(e.`date`) AS Month, 
        ROUND(SUM(e.amount)) AS total,
        ROW_NUMBER() OVER (ORDER BY ROUND(SUM(e.amount))) AS row_num
    FROM credit_card.expenses e 
    JOIN credit_card.catagory c ON e.name = c.name
    WHERE c.catagory = 'Transportation'
    GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT 'Transportation', FLOOR(total/100)*100
FROM Transportation
WHERE row_num = FLOOR((40/100.0) * (SELECT COUNT(*) FROM Transportation));

UPDATE  budget 
set Budget.Budget = 900 WHERE catagory = 'OTHER'

SELECT * from budget b 

select sum(Budget) as monthly_budget
from credit_card.budget b
```

Now we can analyze the monthly expenses with comparisont to the budget:
```sql
---------------------------------------------------------
-- Which months exceeded the budget ordered by overrun -- 
---------------------------------------------------------
SELECT 
	`Year` , m.`Month`, 3500 - m.Total as budget_overrun
FROM months m 
ORDER BY 3500 - m.Total
```


## Visualization with Tableau

In addition, I wanted a visual representation of my spending habits. I chose to create a Tableau dashboard for this purpose. I imported all the tables from the credit_card database. 
(Note : I could not link the interactive dashboard since I dont hold Tableu paid membership)
![צילום מסך 2024-05-15 ב-0 40 56](https://github.com/roni45455/Personal-finance-project/assets/160248285/fc23e90d-28e6-45d5-8dff-6614f7f091ca)








