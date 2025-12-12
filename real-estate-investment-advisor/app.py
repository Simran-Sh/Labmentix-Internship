import streamlit as st
import joblib
import pandas as pd
import numpy as np

# Load models 
@st.cache_resource
def load_models():
    price_model = joblib.load('regression_model.joblib')      # Your actual file
    good_model = joblib.load('classification_model.joblib')   # Your actual file
    feature_names = joblib.load('feature_names.pkl')          # Your feature order
    return price_model, good_model, feature_names

price_model, good_model, feature_names = load_models()
st.success("✅ Models loaded successfully!")

st.title("🏠 Real Estate Investment Advisor")
st.markdown("**Predict future price + investment quality**")

st.header("📝 Enter Property Details")

# Get feature mapping from your trained model
feature_map = {name: i for i, name in enumerate(feature_names)}

# Create input array matching EXACT feature order (20 features)
input_data = np.zeros((1, len(feature_names)))

# User inputs - map to correct positions
col1, col2, col3 = st.columns(3)
with col1:
    bhk = st.number_input("BHK", min_value=1, max_value=5, value=3)
    if 'BHK' in feature_map:
        input_data[0, feature_map['BHK']] = bhk

with col2:
    size = st.number_input("Size (sqft)", min_value=500, max_value=5000, value=2000)
    if 'Size_in_SqFt' in feature_map:
        input_data[0, feature_map['Size_in_SqFt']] = size

with col3:
    price_sqft = st.number_input("Price per SqFt", min_value=0.01, max_value=1.0, value=0.1, step=0.01)
    if 'Price_per_SqFt' in feature_map:
        input_data[0, feature_map['Price_per_SqFt']] = price_sqft

# Additional key features
col1, col2 = st.columns(2)
with col1:
    security = st.selectbox("Security", ["No", "Yes"])
    if 'Security' in feature_map:
        input_data[0, feature_map['Security']] = 1 if security == "Yes" else 0

with col2:
    parking = st.selectbox("Parking", ["No", "Yes"])
    if 'Parking_Space' in feature_map:
        input_data[0, feature_map['Parking_Space']] = 1 if parking == "Yes" else 0

# Predict button
if st.button("🔮 Predict Investment!", type="primary"):
    try:
        future_price = price_model.predict(input_data)[0]
        is_good = good_model.predict(input_data)[0]
        
        st.success("🎯 RESULTS")
        col1, col2 = st.columns(2)
        with col1:
            st.metric("Future Price (5 yrs)", f"₹{future_price:.0f} Lakhs")
        with col2:
            st.metric("Investment", "✅ GREAT BUY!" if is_good else "❌ Avoid")
            
        # Profit estimate
        st.info(f"💰 **Estimated 5-year profit**: ₹{future_price*0.48:.0f} Lakhs (48% growth)")
        
    except Exception as e:
        st.error(f"Prediction error: {str(e)}")
        st.info("Debug: Check if all feature names match training data")

# Show feature info for debugging
with st.expander("🔧 Debug: Feature Mapping"):
    st.write("Model expects these features:", feature_names.tolist())
    st.write("Input shape:", input_data.shape)
