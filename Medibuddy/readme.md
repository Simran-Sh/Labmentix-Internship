# MediBuddy Insurance Data Analysis 📊

## 📌 Project Overview
MediBuddy is a digital healthcare platform by Medi Assist that provides inpatient hospitalization, outpatient services, and corporate wellness benefits.  
This project analyzes insurance policy data to understand how demographic, lifestyle, and health factors influence insurance claims.

The goal is to help the insurance provider make **data-driven decisions** on:
- Risk assessment
- Premium pricing
- Policy segmentation
- Health-based incentives

---

## 📂 Datasets Used

### 1️⃣ Insurance Pricing Data
**File:** `Medibuddy Insurance Data Price.xlsx`

| Column Name | Description |
|------------|------------|
| Policy no. | Unique policy identifier |
| age | Age of the insured person |
| sex | Gender |
| bmi | Body Mass Index |
| charges in INR | Insurance claim amount |

---

### 2️⃣ Personal Details Data
**File:** `Medibuddy Insurance Data Personal Details.xlsx`

| Column Name | Description |
|------------|------------|
| Policy no. | Unique policy identifier |
| children | Number of dependents |
| smoker | Smoking status |
| region | Geographic region |

---

## 🛠️ Tools & Technologies
- Python
- Pandas
- NumPy
- Matplotlib
- Jupyter Notebook (VS Code)

---

## 🔄 Data Preparation Workflow

### Step 1: Load Datasets
### Step 2: Merge Datasets
Performed Left Join on Policy no. to preserve all pricing records
### Step 3: Initial Data Validation
    - Verified row counts
    - Checked missing values
    - Validated categorical distributions

---

## 📊 Exploratory Data Analysis (EDA)
# 1️⃣ Gender vs Insurance Claims
Male and female customers show similar claim distributions
Gender is not a strong constraint for policy eligibility

# 2️⃣ Average Cost per Policy
Mean claim: ₹13,270
Median claim: ₹9,382

Indicates presence of high-value outlier claims

# 3️⃣ Geographic Region Analysis
Southeast region shows higher average claims
Customer distribution across regions is balanced

Region can be used for pricing adjustments, not exclusions

# 4️⃣ Dependents vs Claims
Claim amounts increase with number of dependents (up to 3 children)
Dependents should be considered a risk factor

# 5️⃣ BMI vs Insurance Claims
Weak positive correlation between BMI and claims
BMI provides supporting risk information, not a standalone predictor

# 6️⃣ Smoking Status Impact 🚬
Smokers claim ~4x more than non-smokers
Smoking is the most significant risk factor in the dataset

# 7️⃣ Age vs Claims
Claims increase steadily with age
Older age groups incur significantly higher medical costs
Age should influence premium pricing, not coverage denial

# 8️⃣ Health-Based Discounts (BMI Categories)
BMI categories were created:
Underweight
Normal
Overweight
Obese
Normal BMI → Lowest claims
Obese → Highest claims

BMI can be used for wellness incentives and discounts

---

#  📈 Summary Analysis Table
A multi-dimensional analysis was performed using:
Gender
Smoking status
Region
BMI category

This revealed:
- Obese smokers have the highest claim amounts
- Non-smokers with normal BMI are the lowest-risk customers
- Smoking + obesity is the highest-risk combination

---

#  🏁 Final Business Conclusions
Smoking status is the strongest predictor of insurance claims
BMI and age significantly influence claim amounts
Gender has minimal impact on insurance risk
Region can support localized pricing strategies
Preventive health incentives can reduce long-term claim costs

---

#  🎯 Recommendations
Introduce risk-based premiums for smokers
Offer discounts for healthy BMI
Promote wellness programs for high-risk customers
Use age-based pricing slabs instead of eligibility restrictions

---

#  📌 Author
Simran Sharma
Senior Business Analyst | Data Analytics Enthusiast