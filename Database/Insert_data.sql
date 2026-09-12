-- StreamIQ Streaming Analytics
-- 03_insert_data.sql
-- Loads the CSVs from /Data into the tables created in 02_create_tables.sql.
--

USE streamiq;

SET FOREIGN_KEY_CHECKS = 0; 

-- users -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, country, language, signup_date, acquisition_channel, age_group, account_status);

-- content -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/content.csv'
INTO TABLE content
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(content_id, title, content_type, release_year, runtime_minutes, language, rating, age_rating);

-- genres -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/genres.csv'
INTO TABLE genres
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(genre_id, genre);

-- content_genres -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/content_genres.csv'
INTO TABLE content_genres
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(content_id, genre_id);

-- devices -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/devices.csv'
INTO TABLE devices
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(device_id, user_id, device_type, operating_system, registered_date);

-- subscriptions -------------------------------------------------------
-- auto_renew arrives as the text "True"/"False", so it's staged into a
-- variable and converted to a real boolean (0/1) on the way in.
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/subscriptions.csv'
INTO TABLE subscriptions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(subscription_id, user_id, plan_name, monthly_price_inr, start_date, end_date, status, @auto_renew_raw)
SET auto_renew = (@auto_renew_raw = 'True');

-- payments -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(payment_id, subscription_id, user_id, payment_date, amount_inr, payment_method, payment_status);

-- viewing_sessions -------------------------------------------------------
LOAD DATA LOCAL INFILE '/path/to/StreamIQ-Streaming-Analytics/Data/viewing_sessions.csv'
INTO TABLE viewing_sessions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(session_id, user_id, content_id, started_at, watch_minutes, session_status, discovery_source, video_quality, device_id, completion_pct);

SET FOREIGN_KEY_CHECKS = 1;

-- Quick sanity check: row counts should match the README
-- (users 10000, content 2000, genres 15, content_genres 3106,
--  devices 14848, subscriptions 11455, payments 60000, viewing_sessions 200000)
SELECT 'users' AS tbl, COUNT(*) FROM users
UNION ALL SELECT 'content', COUNT(*) FROM content
UNION ALL SELECT 'genres', COUNT(*) FROM genres
UNION ALL SELECT 'content_genres', COUNT(*) FROM content_genres
UNION ALL SELECT 'devices', COUNT(*) FROM devices
UNION ALL SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'viewing_sessions', COUNT(*) FROM viewing_sessions;
