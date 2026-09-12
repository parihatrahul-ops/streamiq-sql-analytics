-- =========================================================
-- STREAMIQ — PART 5: RETENTION & USER LIFECYCLE ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Retention by cohort & overall
-- ---------------------------------------------------------

-- Q1. What is StreamIQ's 30-day retention rate by signup cohort?
-- =========================================================
WITH user_retention AS (
    SELECT
        u.user_id,
        DATE_FORMAT(u.signup_date, '%Y-%m') AS signup_month,
        MAX(
            CASE
                WHEN v.started_at >= u.signup_date
                 AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
                THEN 1
                ELSE 0
            END
        ) AS retained_30d
    FROM users u
    LEFT JOIN viewing_sessions v
        ON u.user_id = v.user_id
    GROUP BY
        u.user_id,
        signup_month
)
SELECT
    signup_month,
    COUNT(*) AS total_users,
    SUM(retained_30d) AS retained_users,
    ROUND(
        SUM(retained_30d) * 100.0 / COUNT(*),
        2
    ) AS retention_rate
FROM user_retention
GROUP BY signup_month
ORDER BY signup_month;


-- Q2. How does overall retention change across 30, 60 and
-- 90 days?
-- =========================================================
SELECT
    COUNT(DISTINCT u.user_id) AS total_users,

    COUNT(DISTINCT CASE
        WHEN v.started_at >= u.signup_date
         AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
        THEN u.user_id
    END) AS retained_30d,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN v.started_at >= u.signup_date
             AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
            THEN u.user_id
        END) * 100.0 /
        COUNT(DISTINCT u.user_id),
        2
    ) AS retention_rate_30d,

    COUNT(DISTINCT CASE
        WHEN v.started_at >= u.signup_date
         AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 60 DAY)
        THEN u.user_id
    END) AS retained_60d,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN v.started_at >= u.signup_date
             AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 60 DAY)
            THEN u.user_id
        END) * 100.0 /
        COUNT(DISTINCT u.user_id),
        2
    ) AS retention_rate_60d,

    COUNT(DISTINCT CASE
        WHEN v.started_at >= u.signup_date
         AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 90 DAY)
        THEN u.user_id
    END) AS retained_90d,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN v.started_at >= u.signup_date
             AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 90 DAY)
            THEN u.user_id
        END) * 100.0 /
        COUNT(DISTINCT u.user_id),
        2
    ) AS retention_rate_90d

FROM users u
LEFT JOIN viewing_sessions v
    ON u.user_id = v.user_id;


-- ---------------------------------------------------------
-- SECTION B: Retention by segment
-- ---------------------------------------------------------

-- Q3. Which acquisition channels have the highest 30-day
-- retention?
-- =========================================================
SELECT
    u.acquisition_channel,
    COUNT(DISTINCT u.user_id) AS total_users,

    COUNT(DISTINCT CASE
        WHEN v.started_at >= u.signup_date
         AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
        THEN u.user_id
    END) AS retained_users,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN v.started_at >= u.signup_date
             AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
            THEN u.user_id
        END) * 100.0 /
        COUNT(DISTINCT u.user_id),
        2
    ) AS retention_rate

FROM users u
LEFT JOIN viewing_sessions v
    ON u.user_id = v.user_id

GROUP BY u.acquisition_channel
ORDER BY retention_rate DESC;


-- Q4. Which age groups have the highest 30-day retention?
-- =========================================================
SELECT
    u.age_group,
    COUNT(DISTINCT u.user_id) AS total_users,

    COUNT(DISTINCT CASE
        WHEN v.started_at >= u.signup_date
         AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
        THEN u.user_id
    END) AS retained_users,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN v.started_at >= u.signup_date
             AND v.started_at < DATE_ADD(u.signup_date, INTERVAL 30 DAY)
            THEN u.user_id
        END) * 100.0 /
        COUNT(DISTINCT u.user_id),
        2
    ) AS retention_rate

FROM users u
LEFT JOIN viewing_sessions v
    ON u.user_id = v.user_id

GROUP BY u.age_group
ORDER BY retention_rate DESC;


-- ---------------------------------------------------------
-- SECTION C: Growth trend context
-- (needed to interpret cohort size behind the Q1 retention
-- rates - a small cohort's retention % is noisier than a
-- large one's)
-- ---------------------------------------------------------

-- Q5. How does monthly user acquisition change over time?
-- =========================================================
WITH monthly_users AS (
    SELECT
        DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
        COUNT(*) AS new_users
    FROM users
    GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
)
SELECT
    signup_month,
    new_users,
    LAG(new_users) OVER (
        ORDER BY signup_month
    ) AS previous_month_users,
    new_users -
    LAG(new_users) OVER (
        ORDER BY signup_month
    ) AS user_change
FROM monthly_users
ORDER BY signup_month;
