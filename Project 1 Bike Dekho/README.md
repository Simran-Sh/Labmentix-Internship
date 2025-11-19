
Project 1: Bike🚲Dekho (Bike Sales Analysis using Excel)

Project Overview:
The Bike Dekho – Bike Sales Analysis is a hands-on data analysis project that explores sales trends in the biking industry using Microsoft Excel. This project demonstrates how Excel can be effectively utilized for data cleaning, transformation, analysis, and visualization to drive meaningful business insights.
 No Of Rows: 1026
 No. Of Columns: 13 Columns (A to M)


🎯 Project Objectives:
To clean and organize raw bike sales data for better usability (Ref video: https://www.youtube.com/watch?v=oT4emh72fuA&t=92s)
To perform exploratory data analysis (EDA) using Excel formulas and PivotTables.
To uncover key patterns in customer demographics, bike preferences, and sales performance.
To create an interactive and insightful dashboard for decision-makers


Step by Step Guide followed to achieve the above Objectives

[ DAY 1: 16th Nov 2025 - DATA CLEANING AND PREPROCESSING ]

  Step_1a: Upload raw Data of [M1026 Column Rows] To MS Excel
  Step_1b: Make data readable by "Autofitting rows and columns".
          - Head to Top column of the worksheet
		  - Click Triangle to select all rows and columns
		  
    Aufit Columns
		  - Move your between the column labels until double headed arrow appears
		  - Then Double click. Excel will automatically adjust the width to fit the content
		  
	Aufit Rows	  
	      - Move your between the row labels until double headed arrow appears
		  - Then Double click. Excel will automatically adjust the height to fit the content
		  
		  
2. Remove duplicates

Identify and Remove Duplicates for Data Integrity

  Step_2a: Find the column that you strongly believe should be unique overall
  Step_2b Apply Conditional Formating: 
                                      "Home" tab of ribbon -> Conditional Formatting -> Highlight cells rules -> Duplicate Values
									  # Go with the default setting i.e duplicate values will be highlited with red color or/ you can choose to make adjustments as needed
									  # In-case issues accessing Toolbar, see on your RHS top, click on arrow to view "Ribbon Layout". If  "Single Line Ribbon" is checked, then change it to "Classic Ribbon"
  
  Step_2c: Now, select "Data" Tab from Ribbon and click on "Remove Duplicates"
  Step_2d: "Remove Duplicates" Poppup will appear. 
           - Option to Select all Columns / Checkbox to choose one or/ more columns containing duplicates to delete 
		   - Option to tell excel that Header also exist "Data has Headers"
		   # On Succesful Operation, Notification box apprears: 26 duplicate values found and removed. 1000 unique values remain 
  Step_2e: 
  
3. Trimming extra spaces
       #Example: Spaces Prefix or/ Postfix | Suffix in cells of your data i.e leading and trailing whitespace, and also extra spaces between words
  Step_3a: Create a Temp_new Column. Write Formula 
                                                 =trim(Column ref) and then press enter
           - In Column referce, you simply have to select the column with spaces or/ you can do the recommended practice to select the 2nd row of the column. Once the trimming is done, you can drag the effect to other columns
		   - Then select the same new column, [click CTRL + Shift + Down arrow ] and click Copy and then go to our original column and paste special - with values. Thats it
  
3. Eliminating empty Cells / missing values
 Step_3a: Change the sheet into Table.
 Step_3b: From the arrow on headers, try to see if any column has blank rows in-case sheet size / data is more.
 Step_3c: Click on Blank, if exist and manually delete the rows from there
 

4. Spelling Check 
Step_4a: Select the non numneric columns togethor
Step_4b: From the review tab in Ribbon, click on spelling and it will list the mistakes list, if any
          - Sometime, data has no spell erros, so it will display: "Data is perfect"
Step_4c: Use find and replace to make changes to no. of fields togethor quickly

5. Standardized column formats (dates, currency, text)

Steps by Step Guide:
  Step_5a:  For any calculation, you can use, If / nestedif or/Errorif. Syntax is almost same for all 
  Step_5b: Reduce the Income decimaal places by selecting currency and change the decimal places to 0
  Step_5c: Remove $ and commas from Income and convert it to number
  Step_5d: Purchased_Bike (Binary Flag) by changing Status to 1 / 0
  
  
4. Created calculated columns for metrics like Age, Profit Margin, etc.

Steps by Step Guide:
  Step_1: 
  

Exploratory Data Analysis:
Used PivotTables to analyze:
Sales by gender, region, and product category
Preferred bike models by customer demographics
Impact of income and occupation on bike purchasing behavior
Applied COUNTIFS, SUMIFS, VLOOKUP, IF, and DATE functions for derived insights.


