import streamlit as st
import pandas as pd
import numpy as np
import joblib

# Load models
reg_model = joblib.load('regression_model.joblib')
clf_model = joblib.load('classification_model.joblib')

st.title("Real Estate Investment Advisor")

st.sidebar.header("Property Inputs")

state = st.sidebar.selectbox("State", ["Tamil Nadu","Maharashtra","Delhi", "Karnataka"])
city = st.sidebar.text_input("City", "Chennai")
locality = st.sidebar.text_input("Locality", "Locality_100")

property_type = st.sidebar.selectbox("Property Type", ["Apartment","Independent House","Villa"])
bhk = st.sidebar.slider("BHK", 1, 5, 3)
size = st.sidebar.number_input("Size in SqFt", 500, 10000, 2000)
price = st.sidebar.number_input("Current Price (Lakhs)", 10.0, 1000.0, 200.0)
ppsf = price / size  # simple computation

year_built = st.sidebar.slider("Year Built", 1990, 2023, 2010)
age = 2025 - year_built
nearby_schools = st.sidebar.slider("Nearby Schools", 1, 10, 5)
nearby_hospitals = st.sidebar.slider("Nearby Hospitals", 1, 10, 5)
floor_no = st.sidebar.slider("Floor No", 0, 30, 5)
total_floors = st.sidebar.slider("Total Floors", 1, 30, 10)

furnished_status = st.sidebar.selectbox("Furnished Status", ["Unfurnished","Semi-furnished","Furnished"])
pta = st.sidebar.selectbox("Public Transport Accessibility", ["Low","Medium","High"])
parking = st.sidebar.selectbox("Parking Space", ["No","Yes"])
security = st.sidebar.selectbox("Security", ["No","Yes"])
facing = st.sidebar.selectbox("Facing", ["North","South","East","West"])
owner_type = st.sidebar.selectbox("Owner Type", ["Owner","Broker","Builder"])
availability = st.sidebar.selectbox("Availability Status", ["ReadytoMove","UnderConstruction"])

input_dict = {
    'State': state,
    'City': city,
    'Locality': locality,
    'Property_Type': property_type,
    'BHK': bhk,
    'Size_in_SqFt': size,
    'Price_in_Lakhs': price,
    'Price_per_SqFt': ppsf,
    'Year_Built': year_built,
    'Furnished_Status': furnished_status,
    'Floor_No': floor_no,
    'Total_Floors': total_floors,
    'Age_of_Property': age,
    'Nearby_Schools': nearby_schools,
    'Nearby_Hospitals': nearby_hospitals,
    'Public_Transport_Accessibility': pta,
    'Parking_Space': parking,
    'Security': security,
    'Amenities': "Custom",  # placeholder to match columns
    'Facing': facing,
    'Owner_Type': owner_type,
    'Availability_Status': availability
}

input_df = pd.DataFrame([input_dict])

if st.button("Predict"):
    future_price = reg_model.predict(input_df)[0]
    good_investment = clf_model.predict(input_df)[0]

    st.subheader("Results")
    st.write(f"Estimated Price in 5 Years: {future_price:.2f} Lakhs")
    st.write("Good Investment: **Yes**" if good_investment == 1 else "Good Investment: **No**")
