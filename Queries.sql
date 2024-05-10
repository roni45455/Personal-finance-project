
#create table that catagorize expanses
CREATE table credit_card.category as
	select DISTINCT name 
	from credit_card.expanses e 

ALTER table credit_card.catagory 
add column category varchar(50)

# catagorize each expense
UPDATE credit_card.catagory
SET catagory =
    CASE
        WHEN name REGEXP 'מי שבע|חשמל|ביטוח לאומי|פרי טיוי|FREETV|HOT|עיריית|אמישראגז|מאוחדת' THEN 'Bills'
        
        WHEN name REGEXP 'סופרמרקט|מרקט|קשת טעמים|מרכז המזון|דליקטס|עוף תקתוק|רמי לוי|האופה|בשר|בעיר|ממתקי|הפרי והירק|מעיין|המאפייה|סופר קלאב|מינימרקט סולי|שופרסל|דבאח|מאפית|טעם טוב|מיני סופר|להב|פאפא גונס|קיוסק|סופר יעלים|מינמירקט סולי|פיצוצית אורן|THE GROCERY STORE|גרעיני עפולה' THEN 'Groceries'
        
        WHEN name REGEXP 'רד סטור|באג|הסלולר|מולטי|מובייל|GO MOBILE' THEN 'Electronics shopping'
        
        WHEN name REGEXP 'פוט לוקר|אדידס|מיי בייבי|טוונטי פור סבן ב"ש ג|EBAY|אורבניקה|רנואר|קסטרו|NIKE|JD|SHEIN|תמנון|לימה לנד|ONE PROJECT|בגדי ספורט|פשה|קרולינה|RESERVED|FANCORNERCREATION|VANS|טוונטי ירכא עודפים|דרים ספורט ירכא|PULL AND BEAR|פול אנד בר' THEN 'Clothing shopping'
        
        WHEN name REGEXP 'הדרומית| המקסיקני|בוזה|בנדורה|סנדביץ|כנאפה|פיצה|מקדונלדס|דוברין|300 גרם|אגאדיר|שווארמה|בורגר|משלוחה|רובן|קריספי|חומוס|בית הפול|סומבררו|בית העגל|בי בי בי|פלאפל|המקסיקני אב"ג בע"מ|אבולעפיה|גיגסי|כנפת אלקרם|הספריה|מצדה 31|WOLT|KFC|בית הלחם|איסקרים|מנצס|קפה|ברוסקטה|קמפאי|שייק|JAPANIKA|שיפודי|מסעדת|השמן|שוקולטה|סטקית|פיצה' THEN 'Resturants'
        
        WHEN name REGEXP 'יס פלאנט| שרונה|קווינס|מרכז קנדה|יהודה|מובילנד|החרושת 11|DESERT|ברקה|גטאין|שמה שמה|זאפה|טיקטס|בלנדר|בר|פורום|ברדק|נייטס|איוונטר|ברים|גיימס|רוזה' THEN 'Entertainment'
        
        WHEN name REGEXP 'אקדמון|באומן|סטימצקי|דמי רישום|UDEMY|שכר לימוד|לי אופיס' THEN 'Education'
        
        WHEN name REGEXP 'סונול|דור אלון|חוצה צפון|אגד|פנגו|WIND|KORKIFIX|YANGO|GETT|פז|רב קו|EGED|רכבת ישראל|כביש|דרך ארץ - 6 אישי|דלק' THEN 'Transportation'
        
        WHEN name REGEXP 'פנדורה|אקופארם|ברבר 7|דראגסטורס|מספרת|אייקון|סופר פארם|מרכז הספורט והנופש|אפריל|BARBER 7|MYPROTEIN' THEN 'Self_care'
        
        WHEN name REGEXP 'כל בו מרק|אריזול גילת|מקס אילת|אריזול - מרכז גילת|ע.ר. צים שיווק ישיר|מקס אמות באר שבע|איקאה באר שבע|איקאה באר שבע|אייס/ אוטודיפו- אונל|מנורת אלאדין|כלביטון סחר מגרש|המשביר בתי כלבו - קנ|כפר מעליא 25140|WOW STOCK' THEN 'Home'
        
        WHEN name REGEXP 'מזכרות נתב"ג|קונדיטורית מרטין בעמ|פוקס הום- גראנד ב"ש|פרשופ גרנד באר שבע|פרחי אלמוג|סופר-פארם גרנד באר ש|סופר-פארם מעלות 200|מזכרות נתב״ג|א.רות ופרח|DAGUST|פרח רסלאן גרופ בעמ|MYTRIP IL M386ZE|FCB|WDFG BARCELONA|NEWREST TRAVEL RETAI |DUTY FREE MARKET|ירכא|סימפל גלרי|זר פור יו|שוגיס|מתנות לאירועים' THEN 'Presents'
        
        ELSE 'Other'
    END;
   
   
  # show the dataset we will explore
   SELECT * 
   FROM credit_card.expenses e 
   join credit_card.catagory c on e.name = c.name 
   ORDER BY e.`date` 
  
   #summary of monthly expanses per year
   SELECT 
   	YEAR(e.`date`) as 'Year',
   	MONTHNAME(e.`date`) as 'Month', 
   	ROUND(SUM(e.amount))  as 'sum'
   FROM credit_card.expenses e 
   GROUP BY MONTHNAME(e.`date`),YEAR(e.`date`)
   ORDER BY MIN(e.`date`);
  
  
  #monthly avrage for each year
WITH cte AS (
   SELECT 
   	YEAR(e.`date`) as `Year`,
   	MONTHNAME(e.`date`) as `Month`, 
   	ROUND(SUM(e.amount))  as `sum`
   FROM credit_card.expenses e 
   GROUP BY YEAR(e.`date`), MONTHNAME(e.`date`)
)
SELECT `Year`, AVG(`sum`) as `average_monthly_sum`
FROM cte 
GROUP BY `Year`;

  
   #summary of monthly expanses per month per catagory
   SELECT 
   	YEAR(e.`date`) as 'Year',
   	MONTHNAME(e.`date`) as 'Month', 
   	c.catagory as category,
   	ROUND(SUM(e.amount))  as 'sum'
   FROM credit_card.expenses e JOIN credit_card.catagory c ON e.name = c.name
   GROUP BY MONTHNAME(e.`date`), category, YEAR(e.`date`)
   ORDER BY MIN(e.`date`);
  

  
  
 
   
   
   
   
   
   
   
   
   
  
   

   

  
  
   
   
   
   
   
   
   
  






