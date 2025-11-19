**Project 1:** Bike🚲Dekho (Bike Sales Analysis using Excel)

**Project Overview:**
The Bike Dekho is a hands-on data analysis project that explores sales trends in the biking industry using Microsoft Excel. This project demonstrates how Excel can be effectively utilized for data cleaning, transformation, analysis, and visualization to drive meaningful business insights. The dataset contains customer demographics and purchase behavior — useful for understanding which customer segments are most likely to buy bikes.

 <u> xlxs DataSet:</u>
 **No Of Rows:** 1026
**No. Of Columns: 13 Columns** (A to M)

**🎯 Project Objectives:**
1. To clean and organize raw bike sales data for better usability 
2. To perform exploratory data analysis (EDA) using Excel formulas and PivotTables.
3. To uncover key patterns in customer demographics and behaviour towards buying bikes 
4. To create an interactive and insightful dashboard for decision-makers

**Step by Step Guide followed to achieve the above Objectives**

[ DAY 1: 16th Nov 2025 - DATA CLEANING AND PREPROCESSING ]

  Step_1a: UploadED raw Data of [M1026 Column Rows] To MS Excel web
  Step_1b: Made data readable by "Autofitting rows and columns".
          - Headed to Top column of the worksheet
		  - Clicked Triangle to select all rows and columns
		  
    Aufit Columns
		  - Moved  between the column labels until double headed arrow appears
		  - Then Double clicked. Excel automatically adjusted the width to fit the content
		  
	Aufit Rows	  
	      - Moved  between the row labels until double headed arrow appears
		  - Then Double clicked. Excel  automatically adjusted the height to fit the content
		  
**2. Identify and Remove Duplicates for Data Integrity**

  Step_2a: Found the column that I strongly believed should be unique overall
  Step_2b Applied Conditional Formating: 
                "Home" tab of ribbon -> Conditional Formatting -> Highlight cells rules -> Duplicate Values
				<i> # Default setting i.e duplicate values highlited with red color 
				    # Had issues accessing Toolbar, RHS top - clicked on arrow to view "Ribbon Layout". "Single Line Ribbon" was checked, so changed it to "Classic Ribbon" </.>
  
  Step_2c: Selected "Data" Tab from Ribbon and clicked on "Remove Duplicates"
  Step_2d: "Remove Duplicates" Poppup appeared. 
           - Option to Select all Columns / Checkbox to choose one or/ more columns containing duplicates to delete 
		   - Option to tell excel that Header also exist "Data has Headers"
		   # On Succesful Operation, Notification box appreared: 26 duplicate values found and removed. 1000 unique values remain 
  
** 3. Trimming extra spaces **
      <i> #Example: Spaces Prefix or/ Postfix | Suffix in cells of your data i.e leading and trailing whitespace, and also extra spaces between words </i>
  Step_3a: Created a Temp_new Column. **Formula **
                                 <i>  = trim(Column ref) and then press enter </i>
           - In Column referce, selected the column with spaces. Once the trimming is done, you can drag the effect to other columns 
		  <i> # the recommended practice to select the 2nd row of the column</i>
		   - Then selected the same new column, [click CTRL + Shift + Down arrow ] and clicked Copy and then pasted special - with values to original column
  
** 4. Eliminating empty Cells / missing values **
 Step_4a: Changed the sheet into Table
 Step_4b: From the arrow on headers, checked if any column has blank rows in-case sheet size / data is more
 Step_4c: Click on Blank, if exist and manually delete the rows from there
 
** 5. Spelling Check **
Step_5a: Selected the non numneric columns togethor
Step_5b: From the review tab in Ribbon, clicked on "spelling", if any
          - Data has no spell erros, so it displayed: "Data is perfect"
       <i> #In-case of errors, it will automatically list error to erase. And you can Use "find and replace" to make changes to no. of fields togethor quickly </i>

** 6. Standardized column formats **
  Step_6a: Reduced the Income decimaal places by selecting currency and changed the decimal places to 0
  Step_6b: Removed **$** and **,** from Income and converted it to number
  
** 7. Calculated columns for metrics like Age, Profit Margin, etc **
  Step_7a:  Changed ** Purchased_Bike ** column  by changing Status to 1 / 0 ((Binary Flag) using If function
   # For any calculation, you can use, If / nestedif or/Errorif. Syntax is almost same for all 
  
**[ DAY 2: 17th Nov 2025 - EXPLORATORY DATA ANALYSIS ]**

** 1. PivotTables to analyze Datatset **
Step_1a: Created 1st Pivot table to analyse the data
Step_1b: Understaood the use of Legend, Axis, Filter in panel
Step_1c: Started by creating "Sales by Gender"
Steo_1d: Drag Gender to 
Step_1e: Created 2nd Pivot Table for "Sales Distribution by region" 

**[ DAY 3: 18th Nov 2025 - EXPLORATORY DATA ANALYSIS ]**

Step 1f: Created Pivot Table to calculate "Sales by Age group"
Step_1g: Created Pivot Table to check "Income impact on Sales"

5. Applied COUNTIFS, SUMIFS, VLOOKUP, IF, and DATE functions for derived insights.

Reference videos
1. Data Cleaning and Preprocessing: https://www.youtube.com/watch?v=oT4emh72fuA&t=92s
2. Excel Dashboard: https://www.youtube.com/watch?v=l5qkg8gzY6E
3. 
