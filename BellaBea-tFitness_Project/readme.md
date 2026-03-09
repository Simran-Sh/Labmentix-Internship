# Bellabeat Fitness Data Analysis Pipeline

## Project Objective

**Business Goal:**  
Analyze Fitbit fitness tracker data from **33 users** to identify behavioral patterns and provide **actionable marketing recommendations** for Bellabeat's women's wellness app.

### Key Questions

- How do consumers use fitness trackers daily and weekly?
- What are activity, sleep, and calorie burn patterns?
- Which user segments exist and what are their behaviors?
- What features should Bellabeat prioritize for growth?

### Success Metrics

Deliver **5 actionable recommendations** that can improve:

- App engagement
- User retention
- Product feature prioritization

---

# Dataset Overview

| Source | File | Records | Granularity | Users |
|------|------|------|------|------|
| Daily Activity | `dailyActivity_merged.csv` | 940 → 860 (clean) | Daily | 33 |
| Sleep | `sleepDay_merged.csv` | 413 → 410 (clean) | Daily | 24 |
| Weight | `weightLogInfo_merged.csv` | Sparse | Daily | 8 |

**Data Period:**  
April 12 – May 12, 2016 (31 days)

---

# Analytical Pipeline

RAW FITBIT CSVs (8M+ rows)
     ↓ ETL (Python/Pandas)
CLEANED MASTER TABLE (860 rows)
     ↓ Data Warehouse (SQLite)
STAR SCHEMA DATABASE
     ↓ BI Analysis (Tableau/PowerBI)
EXECUTIVE DASHBOARDS + INSIGHTS
     ↓ Business Recommendations
STRAVA CASE STUDY SUBMISSION

---

# Phase 1: Data Extraction & Cleaning (Python / Pandas)

### Input Data

- 940 daily activity records
- 413 sleep records

### Cleaning Process
├── Date standardization (MM/DD/YYYY → YYYY-MM-DD)
├── Remove tracker-not-worn days (79 records: SedentaryMinutes=1440)
├── Remove step outliers (1 record: >30K steps)  
├── Deduplicate sleep records (3 duplicates)
├── Left join: activity + sleep on [Id, activity_date]
└── Quality gates: 91.5% data retention

### Cleaning Steps

- Standardized date format
- Removed tracker-not-worn days  
  (`SedentaryMinutes = 1440`)
- Removed extreme step outlier (>30K steps)
- Removed duplicate sleep records
- Performed **left join on [Id, activity_date]**

### Output

`04_daily_master_final.csv` (860 rows × 21 cols)

---

## Data Quality Results

- Removed **79 tracker-not-worn days (8.4%)**
- Removed **1 extreme outlier**
- Sleep data coverage: **47.7%**
- Final dataset retention: **91.5%**

---

# Phase 2: Data Warehouse Design (SQLite)

### Star Schema Structure
dim_users (33 records)
    └── Id (PK)

fact_daily_activity (860 records)  
    ├── Id (FK)
    ├── activity_date
    ├── TotalSteps (8,248 avg)
    ├── Calories (2,350 avg)
    ├── SedentaryMinutes (950 avg)
    ├── VeryActiveMinutes (21.8 avg)
    └── TotalMinutesAsleep (419 avg)


### Table Overview

**dim_users**

| Column | Description |
|------|------|
| Id | Unique user identifier |

**fact_daily_activity**

| Column | Description |
|------|------|
| Id | User ID (Foreign Key) |
| activity_date | Activity date |
| TotalSteps | Daily steps |
| Calories | Calories burned |
| SedentaryMinutes | Minutes sedentary |
| VeryActiveMinutes | High intensity activity |
| TotalMinutesAsleep | Sleep duration |

### Dataset Metrics

- Users: **33**
- Records: **860**
- Avg Steps: **8,248**
- Avg Calories: **2,350**
- Avg Sedentary Time: **950 minutes**
- Avg Very Active Minutes: **21.8**
- Avg Sleep: **419 minutes (~7 hours)**

---

# Phase 3: Core SQL Analysis

### 1. Weekday Activity Patterns

```sql

-- Q1: Weekday patterns (Tuesday peak: 8,861 steps)
SELECT weekday, AVG(TotalSteps) FROM fact_daily_activity GROUP BY weekday

-- Q2: User segmentation (7 Very Active, 11 Moderate)
SELECT CASE WHEN AVG(steps)>10000 THEN 'Very Active'...

-- Q3: Sleep correlation (7.0hr avg, 410 days coverage)
SELECT AVG(steps), AVG(TotalMinutesAsleep)/60...

-- Q4: Top users (ID 8877689391: 16K avg steps)
SELECT Id, AVG(steps) ORDER BY 2 DESC LIMIT 5

-- Q5: Adherence (23/33 high adherence >25 days)
WITH user_adherence AS (...) SELECT adherence_level, COUNT(*)

```
---

# Phase 4: Business Intelligence Layer
Dashboard 1: Activity Overview
├── KPIs: Steps (8.2K), Calories (2.3K), Users (33)
├── Weekday trends (Tuesday +15% vs Sunday)
├── Activity breakdown (16hr sedentary vs 56min active)
└── Steps vs CDC Goal heatmap

Dashboard 2: User Segmentation
├── Pie: Very Active (21%), Moderate (33%), Light (21%), Sedentary (24%)
├── Top 5 power users bar chart
├── Steps-Calories correlation scatter (r=0.78)
└── User adherence funnel

Dashboard 3: Sleep & Wellness
├── Steps vs Sleep scatter (positive correlation)
├── Sleep distribution histogram (7hr avg)
├── Dual-axis: Activity + Sleep trends
└── Sleep coverage by user matrix

Dashboard 4: Recommendations
├── Funnel visualization
├── Goal achievement timeline
└── Projected ROI metrics

## 📋 TECHNICAL SPECIFICATIONS
Data Volume: 8M+ raw rows → 860 analytical records
Tools: Python 3.11 (Pandas), SQLite 3, Tableau Desktop
Retention: 91.5% post-cleaning
Processing Time: 45 minutes end-to-end
Schema: Star schema (1 fact, 2 dimensions)
Visualizations: 16 charts across 4 dashboards







