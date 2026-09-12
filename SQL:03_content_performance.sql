-- =========================================================
-- STREAMIQ — PART 3: CONTENT PERFORMANCE ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- SECTION A: Top performing content
-- ---------------------------------------------------------

-- Q1. Which content titles receive the most viewing sessions?
-- =========================================================
SELECT c.content_id,
       c.title,
       c.content_type,
       COUNT(v.session_id) AS total_sessions
FROM content c
JOIN viewing_sessions v
    ON c.content_id = v.content_id
GROUP BY c.content_id, c.title, c.content_type
ORDER BY total_sessions DESC
LIMIT 10;


-- Q2. Which content generates the highest total watch time?
-- (Ranked separately from Q1 - a title can be watched by many
-- people briefly, or by fewer people for much longer, and
-- these two queries surface different titles for that reason.)
-- =========================================================
SELECT c.content_id,
       c.title,
       SUM(v.watch_minutes) AS total_watch_minutes
FROM content c
JOIN viewing_sessions v
    ON c.content_id = v.content_id
GROUP BY c.content_id, c.title
ORDER BY total_watch_minutes DESC
LIMIT 10;


-- ---------------------------------------------------------
-- SECTION B: Content type & genre breakdown
-- ---------------------------------------------------------

-- Q3. Which content type is watched the most?
-- =========================================================
SELECT c.content_type,
       COUNT(v.session_id) AS total_sessions,
       SUM(v.watch_minutes) AS total_watch_minutes,
       ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
FROM content c
JOIN viewing_sessions v
    ON c.content_id = v.content_id
GROUP BY c.content_type
ORDER BY total_watch_minutes DESC;


-- Q4. Which genres are the most popular?
-- =========================================================
SELECT g.genre,
       COUNT(v.session_id) AS total_sessions,
       SUM(v.watch_minutes) AS total_watch_minutes
FROM genres g
JOIN content_genres cg
    ON g.genre_id = cg.genre_id
JOIN viewing_sessions v
    ON cg.content_id = v.content_id
GROUP BY g.genre
ORDER BY total_watch_minutes DESC;


-- Q5. Which genres have the highest completion rates?
-- (Restricted to genres with a meaningful sample size so a
-- niche genre with a handful of sessions can't top the list.)
-- =========================================================
SELECT
    g.genre,
    COUNT(v.session_id) AS total_sessions,
    COUNT(DISTINCT v.user_id) AS unique_viewers,
    ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
FROM genres g
JOIN content_genres cg
    ON g.genre_id = cg.genre_id
JOIN viewing_sessions v
    ON cg.content_id = v.content_id
GROUP BY g.genre
HAVING COUNT(v.session_id) >= 100
ORDER BY avg_completion_pct DESC;


-- ---------------------------------------------------------
-- SECTION C: Language & catalog coverage
-- ---------------------------------------------------------

-- Q6. Which languages have the highest viewing activity?
-- =========================================================
SELECT c.language,
       COUNT(v.session_id) AS total_sessions,
       SUM(v.watch_minutes) AS total_watch_minutes,
       ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
FROM content c
JOIN viewing_sessions v
    ON c.content_id = v.content_id
GROUP BY c.language
ORDER BY total_watch_minutes DESC;


-- Q7. Which titles in the catalog have never been watched?
-- Uses a LEFT JOIN so content with zero sessions still shows
-- up (an INNER JOIN would silently drop it).
-- =========================================================
SELECT c.content_id,
       c.title,
       c.content_type,
       c.release_year
FROM content c
LEFT JOIN viewing_sessions v
    ON c.content_id = v.content_id
WHERE v.session_id IS NULL
ORDER BY c.release_year DESC;


-- ---------------------------------------------------------
-- SECTION D: Quality vs. engagement
-- ---------------------------------------------------------

-- Q8. Which highly-rated content also has strong viewer
-- engagement?
-- =========================================================
SELECT
    c.content_id,
    c.title,
    c.rating,
    COUNT(v.session_id) AS total_sessions,
    SUM(v.watch_minutes) AS total_watch_minutes,
    ROUND(AVG(v.completion_pct), 2) AS avg_completion_pct
FROM content c
JOIN viewing_sessions v
    ON c.content_id = v.content_id
WHERE c.rating >= 4.0
GROUP BY c.content_id, c.title, c.rating
ORDER BY total_watch_minutes DESC
LIMIT 20;
