-- =========================================================
-- STREAMIQ — PART 2: USER ENGAGEMENT ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Overall engagement volume
-- ---------------------------------------------------------

-- Q1. How many total viewing sessions does StreamIQ have?
-- =========================================================
SELECT COUNT(*) AS total_sessions
FROM viewing_sessions;


-- Q2. How many unique users have watched content, and how
-- many sessions does that work out to per user on average?
-- =========================================================
SELECT COUNT(DISTINCT user_id) AS unique_viewers,
       COUNT(*) AS total_sessions,
       ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) AS avg_sessions_per_user
FROM viewing_sessions;


-- Q3. What is the average watch time per session?
-- =========================================================
SELECT ROUND(AVG(watch_minutes), 2) AS avg_watch_minutes
FROM viewing_sessions;


-- ---------------------------------------------------------
-- SECTION B: Engagement over time
-- ---------------------------------------------------------

-- Q4. How has monthly viewing activity trended — sessions
-- and active users per month?
-- =========================================================
SELECT DATE_FORMAT(started_at, '%Y-%m') AS view_month,
       COUNT(*) AS total_sessions,
       COUNT(DISTINCT user_id) AS active_users
FROM viewing_sessions
GROUP BY DATE_FORMAT(started_at, '%Y-%m')
ORDER BY view_month;


-- ---------------------------------------------------------
-- SECTION C: Engagement by source, quality & device
-- ---------------------------------------------------------

-- Q5. Which discovery sources generate the most viewing
-- sessions, and how engaged are those sessions?
-- =========================================================
SELECT
    discovery_source,
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_id) AS unique_users,
    ROUND(AVG(watch_minutes), 2) AS avg_watch_minutes,
    ROUND(AVG(completion_pct), 2) AS avg_completion_pct
FROM viewing_sessions
GROUP BY discovery_source
ORDER BY total_sessions DESC;


-- Q6. How does engagement differ by video quality?
-- =========================================================
SELECT video_quality,
       COUNT(*) AS total_sessions,
       ROUND(AVG(watch_minutes), 2) AS avg_watch_minutes,
       ROUND(AVG(completion_pct), 2) AS avg_completion_pct
FROM viewing_sessions
GROUP BY video_quality
ORDER BY avg_watch_minutes DESC;


-- Q7. How does engagement differ by device type?
-- =========================================================
SELECT d.device_type,
       COUNT(*) AS total_sessions,
       ROUND(AVG(vs.watch_minutes), 2) AS avg_watch_minutes,
       ROUND(AVG(vs.completion_pct), 2) AS avg_completion_pct
FROM viewing_sessions vs
JOIN devices d ON vs.device_id = d.device_id
GROUP BY d.device_type
ORDER BY total_sessions DESC;


-- ---------------------------------------------------------
-- SECTION D: Session outcomes & top users
-- ---------------------------------------------------------

-- Q8. What percentage of sessions are completed, stopped
-- or abandoned?
-- =========================================================
SELECT session_status,
       COUNT(*) AS total_sessions,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM viewing_sessions), 2) AS session_percentage
FROM viewing_sessions
GROUP BY session_status
ORDER BY total_sessions DESC;


-- Q9. Which users are the most engaged?
-- =========================================================
SELECT user_id,
       COUNT(*) AS total_sessions,
       SUM(watch_minutes) AS total_watch_minutes,
       ROUND(AVG(completion_pct), 2) AS avg_completion_pct
FROM viewing_sessions
GROUP BY user_id
ORDER BY total_watch_minutes DESC
LIMIT 20;
