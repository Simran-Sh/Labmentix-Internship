import streamlit as st
import pandas as pd
import plotly.express as px
import pyodbc

# 1. Page Config
st.set_page_config(page_title="Ola Analytics Portal", layout="wide")

# 2. Connection
conn = st.connection("sql")

# --- SIDEBAR GLOBAL FILTERS (SLICERS) ---
st.sidebar.title("📊 Global Slicers")

# Date Filter
date_range = st.sidebar.date_input(
    "Select Date Range",
    value=(pd.to_datetime("2024-07-01"), pd.to_datetime("2024-07-31")),
    min_value=pd.to_datetime("2024-07-01"),
    max_value=pd.to_datetime("2024-07-31")
)

# Fetch Locations for Dropdowns
loc_query = "SELECT DISTINCT Pickup_Location, Drop_Location FROM Ola_Dataset_2024"
df_locs = conn.query(loc_query)

pickup_filter = st.sidebar.multiselect("Pickup Location", options=df_locs['Pickup_Location'].unique())
drop_filter = st.sidebar.multiselect("Drop Location", options=df_locs['Drop_Location'].unique())

# --- BASE QUERY BUILDER ---
# This helper string injects our filters into any SQL query we run
where_clause = f" WHERE [Date] BETWEEN '{date_range[0]}' AND '{date_range[1]}'"
if pickup_filter:
    where_clause += f" AND Pickup_Location IN ({str(pickup_filter)[1:-1]})"
if drop_filter:
    where_clause += f" AND Drop_Location IN ({str(drop_filter)[1:-1]})"

# 3. Sidebar Navigation
st.sidebar.title("🚖 Ola Data Hub")
app_mode = st.sidebar.selectbox("Select View", ["Power BI Dashboard", "SQL Question Bank"])

# ---------------------------------------------------------
# VIEW 1: POWER BI DASHBOARD (Visual Analysis)
# ---------------------------------------------------------
if app_mode == "Power BI Dashboard":
    st.title("Executive Dashboard (Ola Ride's Analysis for July 2024)")
    
    # Sheet Selector (Tabs)
    tab1, tab2, tab3, tab4, tab5 = st.tabs(["Overall", "Vehicle Type", "Revenue", "Cancellations", "Ratings & Experience"])

    # --- TAB 1: OVERALL ---
    with tab1:
        st.subheader("Operational Overview (Live Data)")

        # --- 1. Fetch Total Bookings ---
        df_total = conn.query("SELECT COUNT(Booking_ID) AS total FROM Ola_Dataset_2024")
        total_bookings = df_total['total'][0]

        # --- 2. Fetch Revenue Earned ---
        df_rev = conn.query("SELECT SUM(Booking_Value) AS earned FROM Ola_Dataset_2024 WHERE Booking_Status = 'Success'")
        revenue_earned = df_rev['earned'][0]

        # --- 3. Fetch Revenue Lost ---
        df_lost = conn.query("SELECT SUM(Booking_Value) AS lost FROM Ola_Dataset_2024 WHERE Booking_Status != 'Success'")
        revenue_lost = df_lost['lost'][0]

        # --- Display the KPIs ---
        kpi1, kpi2, kpi3 = st.columns(3)

        # Formatting numbers to look clean (e.g., 103020 -> 103.0K)
        kpi1.metric("Total Bookings", f"{total_bookings/1000:.2f}K")
        kpi2.metric("Revenue Earned", f"${revenue_earned/1000000:.1f}M")
        kpi3.metric("Revenue Lost", f"${revenue_lost/1000000:.1f}M",delta="-5%", delta_color="inverse")
        
        # Booking Status Breakdown (Pie Chart)
        q_status = "SELECT Booking_Status, COUNT(*) as Count FROM Ola_Dataset_2024 GROUP BY Booking_Status"
        df_status = conn.query(q_status)
        fig_status = px.pie(df_status, values='Count', names='Booking_Status', title="Booking Status Distribution")
        st.plotly_chart(fig_status, use_container_width=True)

        vol_query = f"SELECT [Date], COUNT(Booking_ID) as Ride_Count FROM Ola_Dataset_2024 {where_clause} GROUP BY [Date] ORDER BY [Date]"
        df_vol = conn.query(vol_query)
        fig_vol = px.area(df_vol, x="Date", y="Ride_Count", title="Daily Ride Volume", line_shape="spline")
        st.plotly_chart(fig_vol, use_container_width=True)

    # --- TAB 2: VEHICLE TYPE ---
    with tab2:
        st.subheader("Performance by Vehicle")
        q_veh = """SELECT Vehicle_Type, AVG(Ride_Distance) as Avg_Dist, 
                   AVG(Customer_Rating) as Avg_Rating FROM Ola_Dataset_2024 GROUP BY Vehicle_Type"""
        df_veh = conn.query(q_veh)
        
        col_v1, col_v2 = st.columns(2)
        with col_v1:
            st.bar_chart(df_veh, x="Vehicle_Type", y="Avg_Dist")
        with col_v2:
            st.line_chart(df_veh, x="Vehicle_Type", y="Avg_Rating")

    # --- TAB 3: REVENUE ---
    with tab3:
        st.subheader("Financial Deep-Dive")
        q_pay = "SELECT Payment_Method, COUNT(*) as Count FROM Ola_Dataset_2024 GROUP BY Payment_Method"
        df_pay = conn.query(q_pay)
        fig_pay = px.treemap(df_pay, path=['Payment_Method'], values='Count', title="Revenue by Payment Method")
        st.plotly_chart(fig_pay, use_container_width=True)

        # Summing Booking_Value for each Customer_ID
        top_cust_query = f""" SELECT TOP 6 Customer_ID, SUM(Booking_Value) as Total_Value  FROM Ola_Dataset_2024 {where_clause} GROUP BY Customer_ID ORDER BY Total_Value DESC"""
        df_top_cust = conn.query(top_cust_query)
        fig_top = px.bar(df_top_cust, x="Customer_ID", y="Total_Value", text_auto='.2s', color="Total_Value")
        st.plotly_chart(fig_top, use_container_width=True)

    # --- TAB 4: CANCELLATIONS ---
    with tab4:
        st.subheader("Cancellation KPI Metrics and Reason Analysis")

        # SQL to get counts
        kpi_query = f"""
            SELECT 
                COUNT(Booking_ID) as Total,
                SUM(CASE WHEN Booking_Status = 'Canceled by Driver' OR Booking_Status = 'Canceled by Customer' THEN 1 ELSE 0 END) as Total_Canceled,
                SUM(CASE WHEN Booking_Status = 'Driver Not Found' THEN 1 ELSE 0 END) as Driver_Not_Found
            FROM Ola_Dataset_2024 {where_clause}
        """
        df_kpi = conn.query(kpi_query)
        
        total = df_kpi['Total'][0]
        canceled = df_kpi['Total_Canceled'][0]
        dnf = df_kpi['Driver_Not_Found'][0]
        cancel_rate = (canceled / total) * 100 if total > 0 else 0
        
        c1, c2, c3 = st.columns(3)
        c1.metric("Cancelled Bookings", f"{canceled}")
        c2.metric("Driver Not Found", f"{dnf}")
        c3.metric("Cancellation Rate", f"{cancel_rate:.1f}%")

        c4, c5 = st.columns(2)
        with c4:
            q_cust = "SELECT Canceled_Rides_by_Customer, COUNT(*) as Count FROM Ola_Dataset_2024 WHERE Booking_Status='Canceled by Customer' GROUP BY Canceled_Rides_by_Customer"
            df_c = conn.query(q_cust)
            st.plotly_chart(px.pie(df_c, values='Count', names='Canceled_Rides_by_Customer', title="Customer Reasons"), use_container_width=True)
        with c5:
            q_drvr = "SELECT Canceled_Rides_by_Driver, COUNT(*) as Count FROM Ola_Dataset_2024 WHERE Booking_Status='Canceled by Driver' GROUP BY Canceled_Rides_by_Driver"
            df_d = conn.query(q_drvr)
            st.plotly_chart(px.pie(df_d, values='Count', names='Canceled_Rides_by_Driver', title="Driver Reasons"), use_container_width=True)

    # --- TAB 5: RATINGS & EXPERIENCE ---
    with tab5:
        st.subheader("Customer vs. Driver Ratings by Vehicle Type")

        # SQL Query to get both averages in one go
        q_ratings = """
        SELECT 
            Vehicle_Type, 
            AVG(Customer_Rating) AS Avg_Customer_Rating, 
            AVG(Driver_Ratings) AS Avg_Driver_Rating 
        FROM Ola_Dataset_2024 
        GROUP BY Vehicle_Type
        """
        df_ratings = conn.query(q_ratings)

        # We use Plotly to create a comparison chart (Power BI style)
        fig_ratings = px.bar(
            df_ratings, 
            x="Vehicle_Type", 
            y=["Avg_Customer_Rating", "Avg_Driver_Rating"],
            barmode="group",
            labels={"value": "Rating (out of 5)", "variable": "Rating Type"},
            title="Comparison: Customer vs. Driver Feedback",
            color_discrete_map={
                "Avg_Customer_Rating": "#00CC96", # Green
                "Avg_Driver_Rating": "#636EFA"    # Blue
            }
        )
        
        st.plotly_chart(fig_ratings, use_container_width=True)

        # Detailed Table for deeper look
        st.write("#### Detailed Ratings Table")
        st.dataframe(df_ratings.style.highlight_max(axis=0, color="#63B6ED"), use_container_width=True)

# ---------------------------------------------------------
# VIEW 2: SQL QUESTION BANK (Direct Queries)
# ---------------------------------------------------------
else:
    st.title("SQL Analysis Questions")
    
    # All your SQL queries organized as a dictionary
    sql_questions = {
        "Q1: Successful Bookings": "SELECT * FROM dbo.Ola_Dataset_2024 WHERE Booking_Status='Success'",
        "Q2: Avg Distance by Vehicle": "SELECT Vehicle_Type, AVG(Ride_Distance) AS Average_Distance FROM DBO.Ola_Dataset_2024 GROUP BY Vehicle_Type",
        "Q4: Top 5 Customers": "SELECT TOP 5 Customer_ID, COUNT(Booking_ID) AS Ride_Count FROM Ola_Dataset_2024 GROUP BY Customer_ID ORDER BY Ride_Count DESC",
        "Q6: Max/Min Ratings (Prime Sedan)": "SELECT MAX(Driver_Ratings) AS Max_Rating, MIN(Driver_Ratings) AS Min_Rating FROM Ola_Dataset_2024 WHERE Vehicle_Type = 'Prime Sedan'",
        "Q8: Avg Customer Rating by Vehicle": "SELECT Vehicle_Type, AVG(Customer_Rating) AS Avg_Customer_Rating FROM Ola_Dataset_2024 GROUP BY Vehicle_Type",
        "Q10: Incomplete Rides with Reason": "SELECT Incomplete_Rides_Reason, COUNT(*) AS Incomplete_Count FROM dbo.Ola_Dataset_2024 WHERE Incomplete_Rides = 1 GROUP BY Incomplete_Rides_Reason"
    }
    
    selected_q = st.selectbox("Choose a question to execute:", list(sql_questions.keys()))
    
    if selected_q:
        # Run Query
        df_result = conn.query(sql_questions[selected_q])
        
        # Display Result
        st.success(f"Execution Successful for {selected_q}")
        
        # Display as chart if more than 1 row and 2 columns
        if len(df_result) > 1 and len(df_result.columns) >= 2:
            st.bar_chart(df_result, x=df_result.columns[0], y=df_result.columns[1])
            
        st.write("### Data Result Table")
        st.dataframe(df_result, use_container_width=True)