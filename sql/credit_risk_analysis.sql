# Create Database to Store our Data
CREATE DATABASE credit_risk_project;
USE credit_risk_project;

# Create Loan Data Table
CREATE TABLE loan_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    marital_status VARCHAR(20),
    education_level VARCHAR(50),
    annual_income DECIMAL(12,2),
    monthly_income DECIMAL(10,2),
    employment_status VARCHAR(20),
    debt_to_income_ratio DECIMAL(5,3),
    credit_score INT,
    loan_amount DECIMAL(12,2),
    loan_purpose VARCHAR(50),
    interest_rate DECIMAL(5,2),
    loan_term INT,
    installment DECIMAL(10,2),
    grade_subgrade VARCHAR(10),
    num_of_open_accounts INT,
    total_credit_limit DECIMAL(12,2),
    current_balance DECIMAL(12,2),
    delinquency_history INT,
    public_records INT,
    num_of_delinquencies INT,
    loan_paid_back INT
);

# Populate the table with data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loan_dataset.csv'
INTO TABLE loan_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(age,
gender,
marital_status,
education_level,
annual_income,
monthly_income,
employment_status,
debt_to_income_ratio,
credit_score,
loan_amount,
loan_purpose,
interest_rate,
loan_term,
installment,
grade_subgrade,
num_of_open_accounts,
total_credit_limit,
current_balance,
delinquency_history,
public_records,
num_of_delinquencies,
loan_paid_back);

# Preview the data in the table
SELECT * from loan_data;
Select Count(*) from loan_data;

# 1 KPI in credit risk analysis (Count Good vs Bad Loans)

SELECT 
    loan_paid_back,
    COUNT(*) AS total_loans
FROM loan_data
GROUP BY loan_paid_back;

# 2 KPI in credit risk analysis (Calculate Default Rate (%))

SELECT 
    ROUND(
        SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS default_rate_percentage
FROM loan_data;

# 3 KPI in credit risk analysis (Credit Score vs Risk)
SELECT 
    CASE 
        WHEN credit_score >= 700 THEN 'High Score'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Medium Score'
        ELSE 'Low Score'
    END AS credit_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) AS defaults
FROM loan_data
GROUP BY credit_band;

# 3.2 KPI in credit risk analysis (TRUE Risk by Credit Score)
SELECT 
    CASE 
        WHEN credit_score >= 700 THEN 'High Score'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Medium Score'
        ELSE 'Low Score'
    END AS credit_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS default_rate_percentage
FROM loan_data
GROUP BY credit_band
ORDER BY default_rate_percentage DESC;

# 4 KPI in credit risk analysis (Income vs Default Risk)
SELECT 
    CASE 
        WHEN annual_income < 20000 THEN 'Low Income'
        WHEN annual_income BETWEEN 20000 AND 50000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS default_rate_percentage
FROM loan_data
GROUP BY income_group
ORDER BY default_rate_percentage DESC;

# 5 KPI in credit risk analysis (Debt-to-Income Ratio (DTI))

SELECT 
    CASE 
        WHEN debt_to_income_ratio < 0.2 THEN 'Low DTI'
        WHEN debt_to_income_ratio BETWEEN 0.2 AND 0.4 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS dti_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS default_rate_percentage
FROM loan_data
GROUP BY dti_group
ORDER BY default_rate_percentage DESC;

# 6 KPI in credit risk analysis (Loan Purpose Risk)
-- Which type of loan is most risky?
SELECT 
    loan_purpose,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        SUM(CASE WHEN loan_paid_back = 0 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS default_rate_percentage
FROM loan_data
GROUP BY loan_purpose
ORDER BY default_rate_percentage DESC;
