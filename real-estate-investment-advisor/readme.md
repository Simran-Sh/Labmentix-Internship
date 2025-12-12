🏠 Real Estate Investment Advisor
ML-Powered Property Investment Decision Tool
Predicts future property value + investment quality for smarter buying decisions

[![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white![Scikit-learn](https://img.shields.io/badge/Scikit-learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo***

🎯 Project Objective
Build an interactive web app that helps real estate investors:
Predict property price in 5 years (Regression)
Classify if it's a "Good Investment" (Classification)
Provide actionable recommendations with profit estimates
Business Problem Solved: Investors need data-driven insights to avoid bad property deals.


| Tool/Library                                                                                                         | Logo                                                       | Purpose in Project |
| -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | ------------------ |
| [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo 🐍                                    | Core programming language for data processing & ML         |                    |
| [![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo 🐼                                    | Data cleaning, feature engineering, 250K row processing    |                    |
| [![NumPy](https://img.shields.io/badge/NumPy-013243?style=for-the-badge&logo 🔢                                      | Numerical computations, array operations for ML inputs     |                    |
| [![Scikit-learn](https://img.shields.io/badge/Scikit-learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor 🌲 | RandomForest models (Regression + Classification), metrics |                    |
| [![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white ⚡     | Interactive web dashboard deployment                       |                    |
| [![Joblib](https://img.shields.io/badge/Joblib-04724D?style=for-the-badge&logo 💾                                    | Model serialization (save/load .pkl files)                 |                    |
| [![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo 📓                                  | Step-by-step development & EDA notebook                    |                    |
| [![VS Code](https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor 💻      | Code editor for app.py & notebook development              |                    |

| Task                      | Target Metric    | Achieved        |
| ------------------------- | ---------------- | --------------- |
| Future Price Prediction   | MAE < 20 Lakhs   | 10.55 Lakhs ✅   |
| Investment Classification | Accuracy > 90%   | 99.8% ✅         |
| Interactive Dashboard     | User-friendly UI | Streamlit App ✅ |

250,000 property records across 20 States, 42 Cities
Key Features (23 total):
├── Location: State, City, Locality
├── Property: BHK, Size_sqft, Property_Type, Age
├── Price: Price_Lakhs, Price_per_SqFt
├── Amenities: Schools, Hospitals, Security, Parking
└── Status: Furnished, Availability, Owner_Type

Data Quality: No missing values, outliers clipped using IQR method.

🔬 Key Insights & Business Logic
1. Future Price Calculation

Future_Price = Current_Price × (1 + growth_rate)^5
Growth Rate: 8% annual average (location-adjusted)
Example: ₹250L today → ₹370L in 5 years (48% total growth)

2. Good Investment Logic (Multi-factor Score)
Good_Investment = (Cheap_Price OR Good_Features)
Cheap_Price = Price_per_SqFt < City_Median
Good_Features = (BHK≥3 + Security=Yes + Parking=Yes)
Threshold: Score ≥ 60% → "GREAT BUY!"

Insight: Only 18.2% properties qualify as good investments.

 Step-by-Step Pipeline
graph TD
    A[Raw Data<br>250K rows<br>Pandas] --> B[Outlier Removal<br>IQR Clipping<br>NumPy]
    B --> C[Feature Engineering<br>Future_Price + Good_Investment<br>Pandas]
    C --> D[Label Encoding<br>Scikit-learn]
    D --> E[Train/Test Split<br>80/20<br>Scikit-learn]
    E --> F[RandomForest Models<br>Regressor + Classifier<br>Scikit-learn]
    F --> G[Model Evaluation<br>10.55L MAE, 99.8% Acc]
    G --> H[Streamlit Deployment<br>Interactive App<br>Joblib]

📈 Model Performance
| Metric        | Price Model       | Investment Model |
| ------------- | ----------------- | ---------------- |
| Test Error    | 10.55 Lakhs MAE   | 99.8% Accuracy   |
| R² Score      | ~0.95 (estimated) | N/A              |
| Training Time | 2 minutes         | 1 minute         |

🚀 Streamlit App Features
📝 Input Form: BHK, Size, Price/SqFt, Amenities (Streamlit)
🔮 One-Click Prediction (Scikit-learn models)
📊 Results: Future Price + Investment Verdict + Profit Estimate
🎨 Professional UI with metrics & balloons

💼 Skills Demonstrated
✅ Data Cleaning & EDA (Pandas, NumPy)
✅ Feature Engineering (Domain Logic)
✅ ML Pipeline (Scikit-learn: Regression + Classification)
✅ Model Evaluation (MAE, Accuracy)
✅ Deployment (Streamlit + Joblib)
✅ Full-Stack ML (Jupyter → Production)
