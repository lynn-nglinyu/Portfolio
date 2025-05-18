# Basic Data Exploration

SELECT *
FROM `graphite-disk-450811-b8.UPI_Payment.Payments` LIMIT 500;

SELECT COUNT(*) AS total_transactions
FROM `graphite-disk-450811-b8.UPI_Payment.Payments`;

# Error in Column names: Renaming columns for easier analysis.

CREATE OR REPLACE TABLE `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned` AS
SELECT 
    `Transaction ID` AS Transaction_ID,
  Timestamp,
  `Sender Name` AS Sender_Name,
  `Sender UPI ID` AS Sender_ID,
  `Receiver Name` AS Receiver_Name,
  `Receiver UPI ID` AS Receiver_ID,
  `Amount _INR_` AS Amount,
  Status,
FROM `graphite-disk-450811-b8.UPI_Payment.Payments`;

# EDA on cleaned dataset Payments_cleaned

SELECT *
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned` LIMIT 100;

SELECT COUNT(*) AS Total_Transactions
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`;

# Daily Transaction Count and Amount
SELECT DATE(Timestamp) AS Transaction_Date,
       COUNT(*) AS Transaction_Count,
       SUM(Amount) AS Total_Amount
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Transaction_Date
ORDER BY Transaction_Date;

# Transaction Count and Amount by Hour
SELECT EXTRACT(HOUR FROM Timestamp) AS hour,
       COUNT(*) AS Transaction_Count,
       SUM(Amount) AS Total_Amount
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Hour
ORDER BY Hour;

# Transaction Count and Amount by Hour
SELECT EXTRACT(DAY FROM Timestamp) AS Day,
       COUNT(*) AS Transaction_Count,
       SUM(Amount) AS Total_Amount
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Day
ORDER BY Day;

# Ten largest transaction
SELECT *
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
ORDER BY Amount DESC
LIMIT 10;

# Average transation value
SELECT Sender_ID,
       COUNT(*) AS Transactions,
       ROUND(SUM(Amount), 2) AS Total_Amount,
       ROUND(AVG(Amount), 2) AS Avg_Transaction_Value
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Sender_ID
ORDER BY Avg_Transaction_Value DESC
LIMIT 10;

# Rates of Success and Failed
SELECT Status,
       COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Status;

SELECT EXTRACT(DAY FROM Timestamp) AS Day,
       COUNTIF(Status = 'FAILED') AS Failed_Transactions,
       COUNT(*) AS Total_Transactions,
       ROUND(COUNTIF(Status = 'FAILED') * 100.0 / COUNT(*), 2) AS Failure_Rate
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Day
ORDER BY Day;

# Top ten most active Senders
SELECT Sender_Name,
       Sender_ID,
       COUNT(*) AS Transaction_Count,
       SUM(Amount) AS Total_Sent
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Sender_Name, Sender_ID
ORDER BY Transaction_Count DESC
LIMIT 10;


# Simulation of PSP in Payments dataset.

SELECT 
  Sender_ID,
  COUNT(*) AS Transactions_Sent,
  SUM(Amount) AS Amount_Sent,
  'PSP' AS Role
FROM `graphite-disk-450811-b8.UPI_Payment.Payments_cleaned`
GROUP BY Sender_ID
LIMIT 20;

