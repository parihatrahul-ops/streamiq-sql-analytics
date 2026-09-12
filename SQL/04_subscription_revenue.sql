-- =========================================================
-- STREAMIQ — PART 4: SUBSCRIPTION & REVENUE ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Subscription base
-- ---------------------------------------------------------

-- Q1. How many subscriptions does StreamIQ have by plan?
-- =========================================================
SELECT plan_name,
       COUNT(*) AS total_subscriptions
FROM subscriptions
GROUP BY plan_name
ORDER BY total_subscriptions DESC;


-- Q2. How many active subscriptions does each plan have?
-- =========================================================
SELECT plan_name,
       COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE status = 'Active'
GROUP BY plan_name
ORDER BY active_subscriptions DESC;


-- ---------------------------------------------------------
-- SECTION B: Recurring revenue (MRR)
-- ---------------------------------------------------------

-- Q3. What is StreamIQ's total monthly recurring revenue,
-- and how is it split across plans?
-- =========================================================
SELECT plan_name,
       SUM(monthly_price_inr) AS monthly_recurring_revenue
FROM subscriptions
WHERE status = 'Active'
GROUP BY plan_name
ORDER BY monthly_recurring_revenue DESC;

SELECT SUM(monthly_price_inr) AS total_mrr
FROM subscriptions
WHERE status = 'Active';


-- ---------------------------------------------------------
-- SECTION C: Realized payment revenue & ARPU
-- ---------------------------------------------------------

-- Q4. What is the total successful payment revenue?
-- =========================================================
SELECT SUM(amount_inr) AS total_successful_revenue
FROM payments
WHERE payment_status = 'Success';


-- Q5. What is the average revenue per paying user (ARPU)?
-- =========================================================
SELECT
    COUNT(DISTINCT user_id) AS paying_users,
    SUM(amount_inr) AS total_successful_revenue,
    ROUND(
        SUM(amount_inr) / COUNT(DISTINCT user_id),
        2
    ) AS arpu
FROM payments
WHERE payment_status = 'Success';

-- ---------------------------------------------------------
-- SECTION D: Payment behavior & risk
-- ---------------------------------------------------------

-- Q6. What is the payment success rate?
-- =========================================================
SELECT
    ROUND(SUM(CASE
                WHEN payment_status = 'Success' THEN 1
                ELSE 0
                END) * 100.0 / COUNT(*), 2) AS payment_success_rate
FROM payments;


-- Q7. How does payment status break down, and what is the
-- payment value associated with each status?
-- =========================================================
SELECT payment_status,
       COUNT(*) AS total_payments,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments), 2) AS pct_of_payments,
       SUM(amount_inr) AS total_value
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;


-- Q8. Which payment methods are used most frequently?
-- =========================================================
SELECT payment_method,
       COUNT(*) AS total_payments,
       SUM(amount_inr) AS total_payment_value
FROM payments
WHERE payment_status = 'Success'
GROUP BY payment_method
ORDER BY total_payments DESC;


-- ---------------------------------------------------------
-- SECTION E: Revenue trend
-- ---------------------------------------------------------

-- Q9. How does revenue change month by month?
-- =========================================================
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       COUNT(*) AS successful_payments,
       SUM(amount_inr) AS monthly_revenue
FROM payments
WHERE payment_status = 'Success'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY payment_month;
