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
