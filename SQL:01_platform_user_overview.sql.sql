-- =========================================================
-- STREAMIQ — PART 1: PLATFORM & USER OVERVIEW
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: User base size & geography
-- ---------------------------------------------------------

-- Q1. How many registered users does StreamIQ have?
-- =========================================================
SELECT COUNT(*) AS total_users
FROM users;


-- Q2. How many countries does StreamIQ have users from?
-- =========================================================
SELECT COUNT(DISTINCT country) AS total_countries
FROM users;


-- Q3. Which countries have the largest user base, and what
-- share of the total does each represent?
-- =========================================================
SELECT country,
       COUNT(*) AS total_users,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) AS user_percentage
FROM users
GROUP BY country
ORDER BY total_users DESC
LIMIT 10;


-- ---------------------------------------------------------
-- SECTION B: Growth over time
-- ---------------------------------------------------------

-- Q4. How many users joined StreamIQ each month?
-- =========================================================
SELECT DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
       COUNT(*) AS new_users
FROM users
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY signup_month;


-- ---------------------------------------------------------
-- SECTION C: User segments (status, channel, age, geography)
-- ---------------------------------------------------------

-- Q5. What is the distribution of users by account status?
-- =========================================================
SELECT account_status,
       COUNT(*) AS total_users,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) AS user_percentage
FROM users
GROUP BY account_status
ORDER BY total_users DESC;


-- Q6. Which acquisition channels bring in the most users,
-- and what share of the total does each represent?
-- =========================================================
SELECT acquisition_channel,
       COUNT(*) AS total_users,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) AS user_percentage
FROM users
GROUP BY acquisition_channel
ORDER BY total_users DESC;


-- Q7. How does the user base differ across age groups?
-- =========================================================
SELECT age_group,
       COUNT(*) AS total_users
FROM users
GROUP BY age_group
ORDER BY total_users DESC;

-- Q8. Which acquisition channels are most successful
-- across different age groups?
-- =========================================================
SELECT
    age_group,
    acquisition_channel,
    COUNT(*) AS total_users,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY age_group),
        2
    ) AS channel_percentage
FROM users
GROUP BY age_group, acquisition_channel
ORDER BY age_group, total_users DESC;

