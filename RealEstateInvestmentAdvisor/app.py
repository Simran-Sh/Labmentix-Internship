#  model was trained on 20 features so,  add 20 features in the app too

import streamlit as st
import joblib
import pandas as pd
import numpy as np

# Load models and features
@st.cache_resource
def load_models():
    price_model = joblib.load('price_model.pkl')
    good_model = joblib.load('good_model.pkl')
    feature_names = joblib.load('feature_names.pkl')
    return price_model, good_model, feature_names

price_model, good_model, feature_names = load_models()

st.title("🏠 Real Estate Investment Advisor")
st.markdown("**Predict future price + investment quality**")

st.header("📝 Enter Property Details")

# Get EXACT feature order from your trained model
print("Feature order:", feature_names)  # Check this in terminal

# Create input matching EXACTLY 20 features from training
input_data = np.zeros((1, len(feature_names)))

# Map user inputs to correct feature positions
feature_map = {name: i for i, name in enumerate(feature_names)}

# User inputs (fill only the features we know positions for)
st.number_input("BHK", key="bhk")
if "BHK" in feature_map:
    input_data[0, feature_map["BHK"]] = st.session_state.bhk

st.number_input("Size (sqft)", key="size")
if "Size_in_SqFt" in feature_map:
    input_data[0, feature_map["Size_in_SqFt"]] = st.session_state.size

st.number_input("Price per SqFt", key="price_sqft")
if "Price_per_SqFt" in feature_map:
    input_data[0, feature_map["Price_per_SqFt"]] = st.session_state.price_sqft

# Security, Parking, Property Type
security = st.selectbox("Security", ["Yes", "No"])
if "Security" in feature_map:
    input_data[0, feature_map["Security"]] = 1 if security == "Yes" else 0

# PREDICT BUTTON
if st.button("🔮 Predict Investment!"):
    future_price = price_model.predict(input_data)[0]
    is_good = good_model.predict(input_data)[0]
    
    st.success("🎯 RESULTS")
    col1, col2 = st.columns(2)
    with col1:
        st.metric("Future Price (5 yrs)", f"₹{future_price:.0f} Lakhs")
    with col2:
        st.metric("Investment", "✅ GREAT BUY!" if is_good else "❌ Avoid")






# import streamlit as st
# import joblib
# import pandas as pd
# import numpy as np

# # Load your trained models
# @st.cache_resource
# def load_models():
#     price_model = joblib.load('price_model.pkl')
#     good_model = joblib.load('good_model.pkl')
#     feature_names = joblib.load('feature_names.pkl')
#     return price_model, good_model, feature_names

# price_model, good_model, feature_names = load_models()

# st.title("🏠 Real Estate Investment Advisor")
# st.markdown("**Predict future price + investment quality in 1 click!**")

# # Input form for investor
# st.header("📝 Enter Property Details")
# col1, col2 = st.columns(2)

# with col1:
#     bhk = st.number_input("BHK (1-5)", min_value=1, max_value=5, value=3)
#     size = st.number_input("Size (sqft)", min_value=500, max_value=5000, value=2500)
#     price_sqft = st.number_input("Price per SqFt (₹)", min_value=0.01, max_value=1.0, value=0.09)

# with col2:
#     age = st.number_input("Property Age (years)", min_value=0, max_value=35, value=10)
#     schools = st.number_input("Nearby Schools (1-10)", min_value=1, max_value=10, value=5)
#     floor = st.number_input("Floor No", min_value=0, max_value=30, value=5)

# # Simple feature inputs
# security = st.selectbox("Security?", ["Yes", "No"])
# parking = st.selectbox("Parking?", ["Yes", "No"])
# property_type = st.selectbox("Property Type?", ["Villa", "House", "Apartment"])

# # Convert to numbers (like we did in Step 5)
# security_num = 1 if security == "Yes" else 0
# parking_num = 1 if parking == "Yes" else 0
# property_num = {"Villa": 0, "House": 1, "Apartment": 2}[property_type]
# total_floors = st.number_input("Total Floors", min_value=1, max_value=30, value=15)

# # Create input for model
# input_data = np.array([[
#     bhk, size, price_sqft, age, schools, floor, 
#     security_num, parking_num, property_num, total_floors
# ]])

# if st.button("🔮 Predict Investment!"):
#     # Predict
#     future_price = price_model.predict(input_data)[0]
#     is_good = good_model.predict(input_data)[0]
    
#     # Results
#     st.success("🎯 **RESULTS**")
#     col1, col2, col3 = st.columns(3)
    
#     with col1:
#         st.metric("Future Price (5 yrs)", f"₹{future_price:.0f} Lakhs")
    
#     with col2:
#         status = "✅ GREAT BUY!" if is_good else "❌ Avoid"
#         st.metric("Investment", status)
    
#     with col3:
#         profit = future_price * 0.48  # 48% growth over 5 years
#         st.metric("Expected Profit", f"₹{profit:.0f} Lakhs")
    
#     st.balloons()
