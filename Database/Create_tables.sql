-- StreamIQ Streaming Analytics
-- 02_create_tables.sql
USE streamiq;

-- ============================================================
-- Core / dimension tables (no dependencies)
-- ============================================================

CREATE TABLE users (
    user_id             VARCHAR(10)   PRIMARY KEY,
    country             VARCHAR(50),
    language            VARCHAR(30),
    signup_date         DATE,
    acquisition_channel VARCHAR(50),
    age_group           VARCHAR(10),
    account_status      VARCHAR(20)
);

CREATE TABLE content (
    content_id      VARCHAR(10)     PRIMARY KEY,
    title           VARCHAR(255),
    content_type    VARCHAR(20),
    release_year    SMALLINT,
    runtime_minutes SMALLINT,
    language        VARCHAR(30),
    rating          DECIMAL(3,1),
    age_rating      VARCHAR(10)
);

CREATE TABLE genres (
    genre_id VARCHAR(10) PRIMARY KEY,
    genre    VARCHAR(50)
);

-- ============================================================
-- Bridge / dependent tables
-- ============================================================

CREATE TABLE content_genres (
    content_id VARCHAR(10) NOT NULL,
    genre_id   VARCHAR(10) NOT NULL,
    PRIMARY KEY (content_id, genre_id),
    CONSTRAINT fk_cg_content FOREIGN KEY (content_id) REFERENCES content(content_id),
    CONSTRAINT fk_cg_genre   FOREIGN KEY (genre_id)   REFERENCES genres(genre_id)
);

CREATE TABLE devices (
    device_id        VARCHAR(10) PRIMARY KEY,
    user_id          VARCHAR(10) NOT NULL,
    device_type      VARCHAR(30),
    operating_system VARCHAR(30),
    registered_date  DATE,
    CONSTRAINT fk_devices_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE subscriptions (
    subscription_id    VARCHAR(10) PRIMARY KEY,
    user_id            VARCHAR(10) NOT NULL,
    plan_name          VARCHAR(30),
    monthly_price_inr  INT,
    start_date         DATE,
    end_date           DATE,
    status             VARCHAR(20),
    auto_renew         BOOLEAN,
    CONSTRAINT fk_subscriptions_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE payments (
    payment_id      VARCHAR(12) PRIMARY KEY,
    subscription_id VARCHAR(10) NOT NULL,
    user_id         VARCHAR(10) NOT NULL,
    payment_date    DATE,
    amount_inr      INT,
    payment_method  VARCHAR(30),
    payment_status  VARCHAR(20),
    CONSTRAINT fk_payments_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id),
    CONSTRAINT fk_payments_user         FOREIGN KEY (user_id)         REFERENCES users(user_id)
);

CREATE TABLE viewing_sessions (
    session_id       VARCHAR(12) PRIMARY KEY,
    user_id          VARCHAR(10) NOT NULL,
    content_id       VARCHAR(10) NOT NULL,
    started_at       DATETIME,
    watch_minutes    INT,
    session_status   VARCHAR(20),
    discovery_source VARCHAR(30),
    video_quality    VARCHAR(10),
    device_id        VARCHAR(10) NOT NULL,
    completion_pct   DECIMAL(5,1),
    CONSTRAINT fk_vs_user    FOREIGN KEY (user_id)    REFERENCES users(user_id),
    CONSTRAINT fk_vs_content FOREIGN KEY (content_id) REFERENCES content(content_id),
    CONSTRAINT fk_vs_device  FOREIGN KEY (device_id)  REFERENCES devices(device_id)
);

-- ============================================================
-- Indexes to speed up the analysis queries 
-- ============================================================

CREATE INDEX idx_subscriptions_status   ON subscriptions(status);
CREATE INDEX idx_payments_status        ON payments(payment_status);
CREATE INDEX idx_payments_date          ON payments(payment_date);
CREATE INDEX idx_sessions_started_at    ON viewing_sessions(started_at);
CREATE INDEX idx_sessions_status        ON viewing_sessions(session_status);
CREATE INDEX idx_users_signup_date      ON users(signup_date);
