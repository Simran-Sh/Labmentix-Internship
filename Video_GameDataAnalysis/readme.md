# 🎮 Video Game Sales & Engagement Analysis

## Problem Statement 
The project aims to analyze and visualize video game sales and engagement data to uncover trends in game popularity, user behavior, and platform performance. By merging sales and engagement data, we seek to offer insights into how game features, platforms, and genres influence sales, wishlists, and ratings. SQL will be used to structure and store the data, while Power BI dashboards will be developed to guide decision-making for game developers, marketers, and publishers.

---

## 🧭 Project Roadmap (High Level)
### We’ll follow this exact flow:
    - Understand datasets 
    - Clean "engagement data" (df_games)
    - Clean "sales data" (df_gameSales)
    - Standardize & prepare keys (Title vs Name)
    - Design Star Schema (SQL)
    - Load data into SQL
    - Analytical SQL queries
    - Power BI dashboards
    - Business insights & storytelling

---

## Architecture
**Phase 1** → Clean CSV raw datasets & Merge (Python – Controlled & Safe)
**Phase 2** → Star Schema (SQL – Warehouse Layer)
**Phase 3** → SQL Views (Business Questions Layer)
**Phase 4** → Power BI (3 Dashboard Story Navigator)

---

## Dataset

| Dataset    | Represents        |Dataset  name        |
| ---------- | ----------------- |---------------------|
| Engagement | Consumer Interest |games_clean.csv      |
| Sales      | Market Revenue    |game_sales_clean.csv |

We have two sides of the same market. Together, they measure: Demand vs Monetization

---

# Phase 1: Data Cleaning & Understanding (Python / Pandas)
Before SQL, modeling, or dashboards, data must be clean, consistent, and reliable

# df_games (Engagement) ➡️ Game-level behavior
This dataset measures interest and player behavior i.e “What do players WANT and EXPERIENCE?”

    - Title: Its the Game name (Unique game identity) which can be Joined with sales data
    - Rating: User review score (numeric). It measures user satisfaction (quality perception)
    - Genres: Game categories (can be multiple). It connects type of game → demand behavior
    - Plays: Number of playthroughs.
    - Backlogs: Number of users who own it (or plan to), but haven’t played yet. i.e Deferred interest.
    - Wishlist: Number of users who wishlisted the game and can also show Pre-release demand / interest.
    - Release Date, Platform, Team (Developer).

## It has derived metrics (wishlist, plays, backlogs)

| Aspect   | Meaning                           |
| -------- | --------------------------------- |
| One row  | One game                          |
| Metrics  | Plays, Wishlist, Backlogs, Rating |
| Platform | ❌ Not platform-specific          |
| Time     | Release date                      |

## DATA UNDERSTANDING
| Aspect               | Meaning                                  |
| -------------------- | ---------------------------------------- |
| `object` dtype       | Data stored as **text**, even if numeric |
| Missing values       | Will break joins, aggregations, visuals  |
| Two datasets         | Need **common key** to merge             |
| Different row counts | Many-to-one relationship                 |

### Best Practice Guide

| Situation                   | Action                |
| --------------------------- | --------------------- |
| Few nulls, non-critical     | Keep as NaN           |
| Many nulls, dimension field | Fill with `'Unknown'` |
| Fact metric nulls           | Investigate or drop   |
| Time fields                 | Never fake dates      |

---

### Problem 1: Useless Column
It’s an index column accidentally saved from CSV

### Problem 2: Dates stored as text
Convert "df_games['Release Date']" to datetime

pd.to_datetime() → converts string → datetime
errors='coerce' → invalid dates become NaT (safe null)

### Problem 3: Data Type Fixation
    - Convert df_games['Team'].string → actual Python list
    - Convert df_games['Genres'] (multi-valued categorical field) 
    - Convert df_games['Reviews'] to string 

### Problem 4: Missing values
| Column  | Action                 | Why                 |
| ------- | ---------------------- | ------------------- |
| Team    | Fill `"Unknown"`       | Dimension attribute |
| Summary | Fill `"Not Available"` | Descriptive         |
| Rating  | Keep NaN               | Don't fake ratings  |
| Genres  |                        | multi-valued column |

### Problem 5: Convert "K currency unit" values to Numbers

| Raw    | Correct |
| ------ | ------- |
| `3.9K` | `3900`  |
| `17K`  | `17000` |
| `679`  | `679`   |

***Solution***
| Code                 | Meaning                   |
| -------------------- | ------------------------- |
| `isinstance(x, str)` | Checks if value is text   |
| `endswith('K')`      | Detects thousands format  |
| `replace('K','')`    | Removes K                 |
| `* 1000`             | Converts to actual number |
| `float(x)`           | Converts clean numbers    |

---

# df_gameSales (Sales) ➡️ Game–Platform–Year sales
    - Name: Game name i.e identity
    - Platform: Console or device.
    - Year: Year of release.
    - Genre: Single Value and Main category.
    - Publisher: Game publisher i.e Business side of gaming.
    - NA_Sales, EU_Sales, JP_Sales, Other_Sales, Global_Sales: Sales by region.


| Aspect   | Meaning                  |
| -------- | ------------------------ |
| One row  | One game on one platform |
| Metrics  | NA, EU, JP, Global sales |
| Platform | ✅ Yes                    |
| Time     | Year                     |

### Problem 1: Year Missing values
| Option    | Why not                |
| --------- | ---------------------- |
| Mean      | Skewed by recent years |
| Mode      | Not stable             |
| Drop rows | Lose valid sales       |
| Median    |robust against outliers |

### Problem 2: Year is float (Conversion to integer)

After data cleaning & fixation - Null fields representing a story
| Game Type | Pattern                                |
| --------- | -------------------------------------- |
| Upcoming  | NaT release, NaN rating, high wishlist |
| New       | Release date present, rating NaN       |
| Mature    | Full engagement + ratings              |

### Problem 3: Missing Publisher values
Publisher is a dimension attribute. and dropping publisher would make us lose real sales numbers. Hence, "fillna('Unknown')"

## JOIN RISK: Game names AND Game Title not standardized
Case differences Leading/trailing spaces. Hence fix them before joining

Common games = 469
df_games total ≈ 1512
df_gameSales total unique games ≈ much larger (16k rows, many duplicates per platform)

## Sales metrics validation
    - Check for negatives or nulls
    - Derived metric consistency check i.e if Global_Sales = sum of regions

Validated that Global_Sales equals the sum of regional sales with minor rounding differences (≤0.02 million units), confirming data integrity and hence no catche aggregation errors

## CLEANED DATASET'S
✔ Applied real-world ETL decision logic
✔ Converted string-lists into real structures
✔ Avoided premature normalization
✔ Cleaned a multi-platform sales fact table
✔ Preserved data (many-to-many relationships) while fixing quality issues
✔ Prepared dataset for star schema modeling

---

# Phase 2: BUILDING THE STAR SCHEMA
    - Create dim_game
    - Attach surrogate keys
    - Prepare fact tables
    - Define SQL schema

## Databasw modes for restricted access
| Mode            | Meaning             |
| --------------- | ------------------- |
| MULTI_USER      | Default, many users |
| SINGLE_USER     | Only one user       |
| RESTRICTED_USER | Only admins         |


## Tables we create in SQL - Actual star schema
### DIMENSIONS
dim_game
dim_platform
dim_genre
dim_publisher
dim_time

### FACTS
fact_game_engagement
fact_game_sales

---

# Power BI 
Used a Hybrid Approach:
| Dashboard            | Data Scope             |
| -------------------- | ---------------------- |
| Engagement Dashboard | All 1512 games         |
| Sales Dashboard      | All 16k rows           |
| Combined Dashboard   | Only 469 matched games |

