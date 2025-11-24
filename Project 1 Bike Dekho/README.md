# 🚲 BikeDekho – Bike Sales Analysis using Excel
*A Complete Excel-based Data Analytics Project*  
**Author:** Simran Sharma | **Intern – Labmentix**  
**Project Duration:** **17th Nov 2025 – 22nd Nov 2025**

## 📌 Project Overview

**BikeDekho** is a hands-on **data analytics project** focused on understanding **bike purchase behavior** across different customer segments using **MS Excel**.  
The aim was to **clean raw data**, perform **Exploratory Data Analysis (EDA)**, and create an **interactive dashboard** to identify **target users most likely to buy a bike**.

---

## 🎯 Project Objectives
✔ Clean and prepare raw data for analysis  
✔ Perform Exploratory Data Analysis (EDA) using Excel  
✔ Understand customer purchasing behavior  
✔ Find which user segments are *most likely* to buy a bike  
✔ Build an **interactive dashboard** with actionable insights

---

## 📂 Dataset Details
| Description | Value |
|-------------|-------|
| Format | `.xlsx` (Excel Dataset) |
| Initial Rows | 1,026 |
| Final Valid Rows | 1,000 |
| Columns Used | 15 |
| Type of Data | **Cross-sectional structured tabular data** |

Each **row = 1 customer**, and each **column = 1 attribute**.

---

## 📑 Data Dictionary – Key Variables

| Attribute | Type | Purpose |
|-----------|------|---------|
| `Cars_Owned` | Numeric (Discrete) | Transport preference |
| `Daily_Miles` | Numeric (Continuous) | Commute behavior |
| `Bike_Purchased` | Binary (0/1) | Target variable |
| `Marital_Status` | Categorical (Nominal) | Segmentation |
| `Education` | Categorical (Ordinal) | Awareness level |
| `Occupation` | Categorical (Nominal) | Economic insight |
| `Income` | Numeric | Buying capability |

---

# 🗓 Project Progress – Day Wise Breakdown

## 📅 **DAY 1 – 17th Nov 2025**
### 🔧 Data Cleaning & Preprocessing

**✔ Steps Performed:**
1. **Uploaded Raw Excel Dataset** to MS Excel Web  
2. **Auto-fitted rows & columns** for readability  
3. **Removed Duplicates** (26 records removed → 1000 valid)  
4. **Trimmed extra spaces** using `=TRIM()`  
5. **Fixed blank cells** using Excel Table filters  
6. **Standardized number formats**  
7. **Created binary (0/1) columns** using `IF()`  

---

## 📅 **DAY 2 – 18th Nov 2025**
### 📊 Exploratory Data Analysis – PivotTables  
✔ Sales by Gender  
✔ Sales by Region  
✔ Sales by Education  
✔ Bike vs Car Preference  

---

## 📅 **DAY 3 – 19th Nov 2025**
### 📈 Deep Dive Analysis – Customer Behaviour  
✔ Sales by Age Group  
✔ Income impact on Sales  
✔ Commute distance analysis  
✔ Marital status impact  
✔ Formulas: `COUNTIFS()`, `SUMIFS()`, `CONCAT()`, `TEXT()`

---

## 📅 **DAY 4 – 20th Nov 2025**
### 📉 Trend Analysis & Charts  
✔ Line Graph – Car Ownership vs Bike Purchase  
✔ Stacked Area Chart – Commute Distance vs Age Group  
✔ Histogram – Income Analysis

---

## 📅 **DAY 5 – 21st Nov 2025**
### 📌 Dashboard Development  
✔ KPI Summary Cards  
✔ Bar, Pie & Column Charts  
✔ Occupation-wise analysis  
✔ Dashboard formatting using slicers & data labels

---

## 📅 **DAY 6 – 22nd Nov 2025**
### 🧠 Final Insights

✔ **North America** leads bike sales – 46%  
✔ **Gender has no major impact**  
✔ **Professionals buy the most bikes – 31%**  
✔ **Medium-income buyers = 65.9% of sales**  
✔ **0 car owners are most likely to buy bikes**  
✔ **Short-distance commuters are top buyers (<1 mile)**  

---

## 🧾 Final Customer Profile

| Attribute | Most Likely Segment |
|-----------|----------------------|
| Region | North America |
| Education | Bachelor’s degree |
| Income | Medium |
| Car Ownership | 0 Cars |
| Commute Distance | Less than 1 mile |
| Gender | No impact |
| Marital Status | Slightly more Single |

---

## 🎯 Business Recommendations

✔ Target **North American professionals**  
✔ Promote **short-distance commuting with bikes**  
✔ Offer **EMI / subscription-based models**  
✔ Focus on **0 car owners**  
✔ Company tie-ups with **IT & corporate offices**

---

## 🛠 Tools Used
- **Microsoft Excel (Web & Desktop)**
- PivotTables & PivotCharts  
- Functions used: `IF`, `COUNTIFS`, `SUMIFS`, `CONCAT`, `TEXT`  
- Excel Dashboard Design & Layout

---

## 📂 Suggested Folder Structure
```
BikeDekho_Project/
│── Data/
│   ├── RawData.xlsx
│   └── CleanedData.xlsx
│
│── Dashboard/
│   └── BikeDekho_Dashboard.xlsx
│
│── Presentation/
│   ├── Final_PPT.pptx
│   └── Presentation_Script.txt
│
└── README.md  ← (This File)
```

---

### ⭐ If you liked this project, kindly ⭐ star this repository  

📩 *Open to feedback & collaboration – feel free to connect!*
