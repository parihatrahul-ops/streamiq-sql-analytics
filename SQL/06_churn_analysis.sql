-- =========================================================
-- STREAMIQ — PART 6: CHURN & SUBSCRIPTION ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Subscription status overview
-- ---------------------------------------------------------

-- Q1. What is the distribution of subscription statuses?
-- =========================================================

SELECT
    status,
    COUNT(*) AS total_subscriptions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM subscriptions),
        2
    ) AS percentage

FROM subscriptions

GROUP BY status

ORDER BY total_subscriptions DESC;


-- Q2. How have cancellations trended month by month?
-- =========================================================

SELECT
    DATE_FORMAT(end_date, '%Y-%m') AS cancel_month,
    COUNT(*) AS cancelled_subscriptions

FROM subscriptions

WHERE status = 'Cancelled'

GROUP BY DATE_FORMAT(end_date, '%Y-%m')

ORDER BY cancel_month;


-- ---------------------------------------------------------
-- SECTION B: Cancellation drivers
-- ---------------------------------------------------------

-- Q3. How long do cancelled subscriptions typically last?
-- =========================================================

SELECT
    plan_name,
    COUNT(*) AS cancelled_subscriptions,
    ROUND(
        AVG(DATEDIFF(end_date, start_date)),
        0
    ) AS avg_subscription_days
FROM subscriptions
WHERE status = 'Cancelled'
GROUP BY plan_name
ORDER BY avg_subscription_days;


-- Q4. Which subscription plans have the highest
-- cancellation rates?
-- =========================================================

SELECT
    plan_name,

    COUNT(*) AS total_subscriptions,

    SUM(
        CASE
            WHEN status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_subscriptions,

    ROUND(
        SUM(
            CASE
                WHEN status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate

FROM subscriptions

GROUP BY plan_name

ORDER BY cancellation_rate DESC;


-- Q5. Does auto-renewal status differ in cancellation rate?
-- =========================================================

SELECT
    auto_renew,

    COUNT(*) AS total_subscriptions,

    SUM(
        CASE
            WHEN status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_subscriptions,

    ROUND(
        SUM(
            CASE
                WHEN status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate

FROM subscriptions

GROUP BY auto_renew

ORDER BY cancellation_rate DESC;


-- ---------------------------------------------------------
-- SECTION C: Who churns
-- ---------------------------------------------------------

-- Q6. Which acquisition channels have the highest
-- subscription cancellation rates?
-- =========================================================

SELECT
    u.acquisition_channel,

    COUNT(*) AS total_subscriptions,

    SUM(
        CASE
            WHEN s.status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_subscriptions,

    ROUND(
        SUM(
            CASE
                WHEN s.status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate

FROM users u

JOIN subscriptions s
    ON u.user_id = s.user_id

GROUP BY u.acquisition_channel

ORDER BY cancellation_rate DESC;


-- Q7. Within each acquisition channel, which subscription
-- plan has the highest cancellation rate?
-- =========================================================

WITH plan_churn AS (

    SELECT
        u.acquisition_channel,
        s.plan_name,

        COUNT(*) AS total_subscriptions,

        SUM(
            CASE
                WHEN s.status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_subscriptions,

        ROUND(
            SUM(
                CASE
                    WHEN s.status = 'Cancelled' THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS cancellation_rate

    FROM users u

    JOIN subscriptions s
        ON u.user_id = s.user_id

    GROUP BY
        u.acquisition_channel,
        s.plan_name
),

ranked_churn AS (

    SELECT
        *,
        RANK() OVER (
            PARTITION BY acquisition_channel
            ORDER BY cancellation_rate DESC
        ) AS churn_rank

    FROM plan_churn
)

SELECT
    acquisition_channel,
    plan_name,
    total_subscriptions,
    cancelled_subscriptions,
    cancellation_rate,
    churn_rank

FROM ranked_churn

WHERE churn_rank = 1

ORDER BY cancellation_rate DESC;
