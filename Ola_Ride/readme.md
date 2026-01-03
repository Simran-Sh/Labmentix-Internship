# 🚖 Ola Ride-Sharing Data Analytics (July 2024)

## 📌 Project Overview
This project involves a comprehensive analysis of a ride-sharing dataset. The primary goal is to extract actionable insights regarding revenue performance, cancellation patterns, and operational bottlenecks.

The project transitions from 
Raw Data ➡️ Strategic Preprocessing ➡️ SQL Analysis ➡️ Dynamic Visualization.

## ** Format: ** CSV (Comma Separated Values)
*Rows:* ~103,000 records
Columns: 21 features
Date Range: July 2024
Domain: Transportation / Gig Econom

## 📝 Column Descriptors

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `Date` | **Date** | The specific calendar date of the booking. |
| `Time` | **Time** | The timestamp when the booking was requested. |
| `Booking_ID` | **String** | A unique identifier for every booking request. |
| `Booking_Status` | **Categorical** | Final status: `Success`, `Cancelled by Customer`, or `Cancelled by Driver`. |
| `Customer_ID` | **String** | Unique identifier for the customer (Anonymized). |
| `Vehicle_Type` | **Categorical** | Category: *Auto, Prime Sedan, Mini, Bike, eBike, Prime SUV*. |
| `Pickup_Location` | **String** | The area where the customer requested pickup. |
| `Drop_Location` | **String** | The destination area. |
| `V_TAT` | **Integer** | **Vehicle Turnaround Time**: Time taken (s) for driver to accept. |
| `C_TAT` | **Integer** | **Customer Turnaround Time**: Time taken (s) for customer to board. |
| `Cancelled_R_by_Cust` | **String** | Reason for customer cancellation (e.g., *Change of plans*). |
| `Cancelled_R_by_Drvr` | **String** | Reason for driver cancellation (e.g., *Personal & Car issues*). |
| `Incomplete_Rides` | **Binary** | Started trips not completed (`1` = Yes, `0` = No). |
| `Incomplete_R_Reason` | **String** | Reason for premature end (e.g., *Vehicle Breakdown*). |

---

## 🛠 Strategic Data Cleaning & Observations

> [!IMPORTANT]
> **Observation on Missing Data:** Nearly **38%** of core ride metrics (Ratings, Payment Method, TAT) contain null values.

In ride-sharing analytics, Nulls are often **"Conditional"** rather than "Missing":
* **The Logic:** If a `Booking_Status` is marked as `Cancelled`, it is logically impossible to have a `Driver_Rating`, `V_TAT`, or `Payment_Method`.
* **The Strategy:** Instead of dropping rows, we treat these as **Categorical Absences**.
  * **Incomplete Rides:** We identified `39,057` records where ratings are missing, matching the count of non-success records exactly.

---

# 🔍 SQL Insights & Business Questions
The data was migrated to SQL Server (SSMS) to perform high-performance querying. Below are the key findings:

---
## Booking Success Rate
Tracking the volume of rides that successfully reached the destination
![Booking Success Rate](Successful_BookingRecords.png)

---
## Vehicle Performance (Distance)
Identifying which vehicle types are preferred for long-distance vs. short-distance travel.
![Average_Distance_VehicleType](Average_Distance_VehicleType.png)

---
## Customer Cancellation Trends
Analyzing the primary reasons why customers abandon bookings
![Total_cancelled_rides_by_customer1](Total_cancelled_rides_by_customer1.png)

---
# Loyalty Analysis (Top 5 Customers)
Identifying the power users with the highest ride frequency
![top5customers_withmaxRides](top5customers_withmaxRides.png)

---
## Driver Behavior & Operational Issues
Quantifying cancellations due to personal/car-related issues by drivers
![CancelledbyDriver_Car_Personalissue_Count](CancelledbyDriver_Car_Personalissue_Count.png)

---
# Rating Benchmarks for PrimeSedan
Evaluating the quality of service for premium segments like Prime Sedan.
![primeSedan_Min_max_DriverRating](primeSedan_Min_max_DriverRating)

---