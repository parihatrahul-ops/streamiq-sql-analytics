-- =========================================================
-- STREAMIQ — PART 7: ADVANCED SQL / PRODUCT ANALYTICS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Revenue trend (running total)
-- ---------------------------------------------------------

-- Q1. What does cumulative revenue look like month over
-- month?
-- =========================================================
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
        SUM(amount_inr) AS revenue
    FROM payments
    WHERE payment_status = 'Success'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT
    payment_month,
    revenue,
    SUM(revenue) OVER (ORDER BY payment_month) AS cumulative_revenue
FROM monthly_revenue
ORDER BY payment_month;


-- ---------------------------------------------------------
-- SECTION B: User engagement segmentation
-- ---------------------------------------------------------

-- Q2. If users are split into four equal-sized engagement
-- tiers by total watch time, how does each tier compare?
-- =========================================================
WITH user_engagement AS (
    SELECT
        user_id,
        COUNT(*) AS total_sessions,
        SUM(watch_minutes) AS total_watch_minutes,
        ROUND(AVG(completion_pct), 2) AS avg_completion_pct
    FROM viewing_sessions
    GROUP BY user_id
),
engagement_tiers AS (
    SELECT
        *,
        NTILE(4) OVER (
            ORDER BY total_watch_minutes DESC
        ) AS engagement_tier
    FROM user_engagement
)
SELECT
    engagement_tier,
    COUNT(*) AS users_in_tier,
    ROUND(AVG(total_sessions), 2) AS avg_sessions,
    ROUND(AVG(total_watch_minutes), 2) AS avg_watch_minutes,
    ROUND(AVG(avg_completion_pct), 2) AS avg_completion_pct
FROM engagement_tiers
GROUP BY engagement_tier
ORDER BY engagement_tier;


-- ---------------------------------------------------------
-- SECTION C: Platform deep dive
-- ---------------------------------------------------------

-- Q3. Which operating systems have the highest viewing
-- activity and completion?
-- =========================================================
SELECT
    d.operating_system,
    COUNT(v.session_id) AS total_sessions,
    COUNT(DISTINCT v.user_id) AS unique_users,
    SUM(v.watch_minutes) AS total_watch_minutes,
    ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
FROM devices d
JOIN viewing_sessions v
    ON d.device_id = v.device_id
GROUP BY d.operating_system
ORDER BY total_watch_minutes DESC;


-- Q4. Ranking genres by completion rate (minimum sample
-- size enforced so low-volume genres can't top the list).
-- =========================================================
WITH genre_performance AS (
    SELECT
        g.genre,
        COUNT(v.session_id) AS total_sessions,
        COUNT(DISTINCT v.user_id) AS unique_users,
        SUM(v.watch_minutes) AS total_watch_minutes,
        ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
    FROM genres g
    JOIN content_genres cg
        ON g.genre_id = cg.genre_id
    JOIN viewing_sessions v
        ON cg.content_id = v.content_id
    GROUP BY g.genre
    HAVING COUNT(v.session_id) >= 1000
),
ranked_genres AS (
    SELECT
        *,
        RANK() OVER (ORDER BY avg_completion_pct DESC) AS genre_rank
    FROM genre_performance
)
SELECT
    genre,
    total_sessions,
    unique_users,
    total_watch_minutes,
    avg_completion_pct,
    genre_rank
FROM ranked_genres
ORDER BY genre_rank;


-- ---------------------------------------------------------
-- SECTION D: Subscriber value
-- ---------------------------------------------------------

-- Q5. Within each plan, who are the most engaged active
-- subscribers?
-- =========================================================
WITH active_subscribers AS (
    SELECT DISTINCT
        user_id,
        plan_name
    FROM subscriptions
    WHERE status = 'Active'
),
user_engagement AS (
    SELECT
        v.user_id,
        COUNT(v.session_id) AS total_sessions,
        SUM(v.watch_minutes) AS total_watch_minutes,
        ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
    FROM viewing_sessions v
    GROUP BY v.user_id
),
subscriber_engagement AS (
    SELECT
        a.user_id,
        a.plan_name,
        e.total_sessions,
        e.total_watch_minutes,
        e.avg_completion_pct
    FROM active_subscribers a
    JOIN user_engagement e
        ON a.user_id = e.user_id
    WHERE e.total_sessions >= 20
),
ranked_subscribers AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY plan_name
            ORDER BY total_watch_minutes DESC
        ) AS plan_engagement_rank
    FROM subscriber_engagement
)
SELECT
    user_id,
    plan_name,
    total_sessions,
    total_watch_minutes,
    avg_completion_pct,
    plan_engagement_rank
FROM ranked_subscribers
WHERE plan_engagement_rank <= 10
ORDER BY plan_name, plan_engagement_rank;
