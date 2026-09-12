# StreamIQ — Streaming Platform SQL Analytics

### User Behaviour • Content Performance • Revenue • Retention • Churn

> Portfolio Project | MySQL | SQL Analytics
📊 [View the full project presentation (PDF)](Documentation/StreamIQ.pdf)

---

## 📌 Project Overview

**StreamIQ** is a fictional streaming platform created for this SQL analytics portfolio project.

The objective is to analyze user behaviour, content consumption, subscriptions, payments, retention, churn, and platform performance using **MySQL**, across multiple countries, languages, devices, subscription plans and payment methods.

The project demonstrates how SQL can be used to answer practical business questions and turn relational data into actionable analytical insights.

### Business Questions

- Who are the platform's users?
- Which acquisition channels bring in the most users?
- How actively do users consume content?
- Which content and genres perform best?
- How does subscription revenue behave?
- Which user segments show stronger engagement and retention?
- Where are subscription cancellations concentrated?
- What can advanced SQL reveal about platform behaviour?

---

## 📊 Dataset at a Glance

The StreamIQ dataset contains **8 relational tables**.

| Table | Rows | Purpose |
|---|---:|---|
| `users` | 10,000 | User information and acquisition data |
| `content` | 2,000 | Movies and series catalog |
| `genres` | 15 | Genre reference data |
| `content_genres` | 3,106 | Content-to-genre mapping |
| `devices` | 14,848 | Registered user devices |
| `subscriptions` | 11,455 | Subscription plans and lifecycle |
| `payments` | 60,000 | Payment transaction history |
| `viewing_sessions` | 200,000 | User viewing activity |

---

## 🗂️ Database Structure

The project uses a relational database consisting of user, content, engagement, subscription and payment data.

```text
users
 ├── subscriptions
 │       └── payments
 │
 ├── devices
 │       └── viewing_sessions
 │
 └── viewing_sessions
         └── content
                └── content_genres
                       └── genres
```


## 🔎 SQL Analysis & Business Insights

The project is divided into 7 analytical parts, progressing from basic user analysis to advanced product analytics.

## 🟡 01 — Platform & User Overview

SQL File: SQL/01_platform_user_overview.sql

This section analyzes the size, geography, growth, acquisition channels and demographic structure of the StreamIQ user base.

Q1. How many registered users does StreamIQ have?
Explanation

The users table is counted using COUNT(*) to determine the total number of registered users.

Business Insight

This establishes the overall size of the StreamIQ user base and provides the denominator for percentage-based user analysis.

Q2. How many countries does StreamIQ have users from?
Explanation

The query uses:

COUNT(DISTINCT country)

to count the number of unique countries represented in the user base.

Business Insight

This measures the geographic reach of the platform and helps understand how widely StreamIQ is distributed across markets.

Q3. Which countries have the largest user base, and what share of the total does each represent?
Explanation

Users are grouped by country and ranked by total user count.

The percentage of total users is calculated as:

Country Users ÷ Total Users × 100
Business Insight

This identifies the largest user markets and shows their contribution to the overall user base.

This can support decisions around:

Marketing
Localization
Content strategy
Market expansion
Q4. How many users joined StreamIQ each month?
Explanation

Signup dates are converted into monthly periods using DATE_FORMAT() and users are grouped by signup month.

Business Insight

Monthly signup trends help identify periods of stronger or weaker user acquisition and provide context for overall platform growth.

Q5. What is the distribution of users by account status?
Explanation

Users are grouped by account_status and the percentage of each status is calculated.

Business Insight

This helps distinguish the total registered audience from the currently active and inactive user base.

Q6. Which acquisition channels bring in the most users, and what share of the total does each represent?
Explanation

Users are grouped by acquisition_channel.

The query calculates both total users and each channel's percentage of the overall user base.

Key Result

Organic Search is the largest acquisition channel with 2,810 users.

Business Insight

This identifies which acquisition sources contribute the largest share of StreamIQ's user base.

Q7. How does the user base differ across age groups?
Explanation

Users are grouped by age_group and counted.

Business Insight

This provides demographic segmentation and identifies the largest audience groups.

Q8. Which acquisition channels are most successful across different age groups?
Explanation

Users are grouped by both age_group and acquisition_channel.

A window function calculates the percentage contribution of each acquisition channel within its age group.

SQL Technique
SUM(COUNT(*)) OVER (PARTITION BY age_group)
Business Insight

This reveals whether different age groups have different acquisition patterns and can support more targeted marketing strategies.

## 🟡 02 — User Engagement Analysis

SQL File: SQL/02_user_engagement.sql

This section analyzes how users interact with StreamIQ content and measures viewing behaviour.

Q1. How many total viewing sessions does StreamIQ have?
Explanation

The viewing_sessions table is counted using COUNT(*).

Key Result

200,000 viewing sessions.

Business Insight

This establishes the overall volume of recorded viewing activity.

Q2. How many unique users have watched content, and how many sessions does that work out to per user on average?
Explanation

The query calculates:

Unique viewers
Total viewing sessions
Average sessions per user

Unique viewers are calculated using:

COUNT(DISTINCT user_id)
Business Insight

This separates the size of the viewing audience from how frequently users consume content.

Q3. What is the average watch time per session?
Explanation

Average watch time is calculated using:

AVG(watch_minutes)
Business Insight

Average watch time provides a session-level measure of engagement and consumption intensity.

Q4. How has monthly viewing activity trended?
Explanation

Viewing sessions are grouped by month.

The analysis calculates:

Total sessions
Monthly active viewers
Important Definition

In this project, active users means users who generated at least one viewing session during that month.

It does not represent general account activity.

Business Insight

Monthly viewing trends help identify changes in platform engagement over time.

Q5. Which discovery sources generate the most viewing sessions, and how engaged are those sessions?
Explanation

Sessions are grouped by discovery_source.

The query calculates:

Total sessions
Unique users
Average watch minutes
Average completion percentage
Discovery Sources
Recommendation
Continue Watching
Search
Trending
Auto
Business Insight

This helps evaluate which content-discovery mechanisms generate viewing activity and stronger engagement.

Q6. How does engagement differ by video quality?
Explanation

Sessions are grouped by video_quality.

The query compares:

Total sessions
Average watch time
Average completion percentage
Business Insight

This identifies differences in viewing behaviour across streaming-quality levels.

Q7. How does engagement differ by device type?
Explanation

The viewing_sessions table is joined with the devices table using device_id.

The analysis compares:

Total sessions
Average watch time
Average completion percentage
Business Insight

This helps identify differences in viewing behaviour across device types.

Q8. What percentage of sessions are completed, stopped or abandoned?
Explanation

Sessions are grouped by session_status.

Key Results
Session Status	Sessions
Completed	124,200
Stopped	39,906
Abandoned	35,894
Business Insight

Completed sessions represent the largest session-status category.

The distribution also highlights the volume of sessions that stop or are abandoned before completion.

Q9. Which users are the most engaged?
Explanation

Users are ranked using:

Total sessions
Total watch minutes
Average completion percentage

The query returns the top 20 users by total watch time.

Business Insight

This identifies highly engaged users and provides a basis for studying successful engagement patterns and retention strategies.

## 🟡 03 — Content Performance Analysis

SQL File: SQL/03_content_performance.sql

This section analyzes content popularity, watch time, genres, languages and viewer engagement.

Q1. Which content titles receive the most viewing sessions?
Explanation

The content table is joined with viewing_sessions.

Content is grouped and ranked by total viewing sessions.

Business Insight

This identifies titles attracting the highest number of viewing sessions and can support content promotion and recommendation strategies.

Q2. Which content generates the highest total watch time?
Explanation

Total watch time is calculated using:

SUM(watch_minutes)
Important Difference

Total viewing sessions and total watch time measure different aspects of content performance.

A title can have:

Many short sessions
Fewer but much longer sessions
Business Insight

Using both metrics provides a more complete view of content popularity and consumption depth.

Q3. Which content type is watched the most?
Explanation

Content is grouped into:

Movie
Series

The analysis compares:

Total sessions
Total watch time
Average completion percentage
Dataset Composition
Content Type	Titles
Movie	1,233
Series	767
Business Insight

This helps determine whether users consume more movie-based or series-based content.

Q4. Which genres are the most popular?
Explanation

The analysis uses the many-to-many relationship:

genres
   ↓
content_genres
   ↓
content
   ↓
viewing_sessions
Business Insight

Genre analysis can support:

Content acquisition
Recommendation systems
Catalog planning
Personalization

Q5. Which genres have the highest completion rates?
Explanation

Average completion percentage is calculated for each genre.

A minimum sample size of 100 sessions is required.

Why use a sample-size filter?

A genre with only a few sessions could produce an unusually high average because of a very small sample.

Business Insight

The threshold makes the comparison more meaningful by reducing the effect of very small samples.

Q6. Which languages have the highest viewing activity?
Explanation

Content is grouped by language and joined with viewing sessions.

The analysis compares:

Total sessions
Total watch time
Average completion percentage
Business Insight

This identifies which content languages generate the highest levels of consumption and can support localization decisions.

Q7. Which titles in the catalog have never been watched?
Explanation

A LEFT JOIN is used between content and viewing_sessions.

Titles where the session ID is NULL are identified as having no recorded viewing sessions.

SQL Technique
LEFT JOIN
Why use LEFT JOIN?

An INNER JOIN would remove content that has no viewing sessions.

Business Insight

This identifies potentially underutilized or undiscovered content in the catalog.

Q8. Which highly-rated content also has strong viewer engagement?
Explanation

Content with a rating of at least 4.0 is selected.

The results are then ranked using:

Total sessions
Total watch time
Average completion percentage
Business Insight

This combines content quality with actual viewer behaviour instead of relying on ratings alone.

## 🟡 04 — Subscription & Revenue Analysis

SQL File: SQL/04_subscription_revenue.sql

This section analyzes subscription plans, recurring revenue, payment performance and revenue trends.

Q1. How many subscriptions does StreamIQ have by plan?
Explanation

Subscriptions are grouped by plan_name and counted.

Key Result

StreamIQ contains 11,455 subscription records.

The Standard plan has the highest number of subscription records with 3,579.

Business Insight

Plan distribution shows how subscription records are distributed across the available pricing tiers.

Q2. How many active subscriptions does each plan have?
Explanation

Only subscriptions where:

status = 'Active'

are included.

Business Insight

This focuses specifically on the active subscription base rather than historical subscription records.

Q3. What is StreamIQ's total monthly recurring revenue?
Explanation

Monthly recurring revenue is calculated by summing monthly_price_inr for active subscriptions.

Important Definition

This represents an active-subscription MRR proxy rather than a complete accounting measure of recurring revenue.

Business Insight

It provides an estimate of recurring subscription value based on active subscription records.

Q4. What is the total successful payment revenue?
Explanation

Only successful payments are included:

payment_status = 'Success'
Dataset

The payment table contains 60,000 available payment records.

Business Insight

This measures the recorded successful payment value in the available payment history.

Q5. What is the average revenue per paying user?
Explanation

The calculation is:

Successful Payment Revenue
÷
Distinct Paying Users
Important Definition

This represents average revenue per paying user across the available payment history.

It should not be interpreted as monthly ARPU.

Business Insight

This provides a high-level view of recorded revenue associated with paying users.

Q6. What is the payment success rate?
Explanation

The payment success rate is calculated by dividing successful payment attempts by total payment attempts.

Key Results
Payment Status	Records
Success	55,791
Failed	4,209
Business Insight

The majority of recorded payment attempts are successful.

Payment success is important because failed transactions can affect revenue realization and customer experience.

Q7. How does payment status break down, and what is the payment value associated with each status?
Explanation

Payments are grouped by payment_status.

The query calculates:

Total payments
Percentage of payments
Total payment value
Business Insight

This helps quantify both payment volume and value associated with successful and failed payment attempts.

Q8. Which payment methods are used most frequently?
Explanation

Successful payments are grouped by payment_method.

Key Result

UPI is the most frequently recorded payment method with 25,174 records.

Other methods include:

Credit Card
Debit Card
Net Banking
Wallet
Business Insight

This identifies the most commonly used payment methods and can help prioritize payment experience improvements.

Q9. How does revenue change month by month?
Explanation

Successful payments are grouped by payment month.

The analysis calculates:

Successful payment count
Monthly revenue
Business Insight

This provides a time-series view of recorded successful payment revenue and helps identify stronger or weaker revenue periods.

## 🟡 05 — Retention & User Lifecycle Analysis

SQL File: SQL/05_retention_analysis.sql

This section examines user engagement after signup and compares retention across different user segments.

Q1. What is StreamIQ's 30-day retention rate by signup cohort?
Explanation

Users are grouped by signup month.

A user is considered retained when they generate at least one viewing session during the first 30 days after signup.

SQL Techniques
CTE
LEFT JOIN
CASE
Date calculations
Conditional aggregation
Business Insight

Cohort analysis allows retention to be compared across different signup periods.

Q2. How does overall retention change across 30, 60 and 90 days?
Explanation

The query calculates the number and percentage of users who generate viewing activity within:

30 days
60 days
90 days

after signup.

Business Insight

This shows whether initial user engagement continues as the observation window becomes longer.

Q3. Which acquisition channels have the highest 30-day retention?
Explanation

Users are grouped by acquisition channel and checked for viewing activity within the first 30 days after signup.

Business Insight

This compares early engagement retention across acquisition sources.

A channel with fewer users but stronger retention may be more valuable than one producing many users with weaker retention.

Q4. Which age groups have the highest 30-day retention?
Explanation

Users are grouped by age group and evaluated using the same 30-day viewing-retention definition.

Business Insight

This identifies audience segments that demonstrate stronger early engagement.

Q5. How does monthly user acquisition change over time?
Explanation

Monthly signup counts are compared with the previous month using:

LAG(new_users) OVER (ORDER BY signup_month)

The query calculates:

Current month users
Previous month users
Change in users
SQL Technique

LAG window function

Business Insight

This provides growth context alongside the cohort-retention analysis.

⚠️ Retention Definition

The retention analysis measures viewing activity after signup, not subscription renewal.

The viewing-session data is synthetic and is not constrained to active subscription dates.

Therefore, these metrics should be described as:

30/60/90-day viewing engagement retention

rather than subscription retention.

## 🟡 06 — Churn & Subscription Analysis

SQL File: SQL/06_churn_analysis.sql

This section analyzes subscription cancellations and identifies segments associated with higher cancellation rates.

Q1. What is the distribution of subscription statuses?
Key Results
Status	Records
Active	6,177
Cancelled	2,668
Expired	2,610
Business Insight

This provides an overview of the subscription lifecycle and the distribution of active, cancelled and expired subscription records.

Q2. How have cancellations trended month by month?
Explanation

Cancelled subscriptions are grouped by the month of end_date.

Business Insight

This identifies periods with higher or lower cancellation volume and provides a starting point for deeper churn analysis.

Q3. How long do cancelled subscriptions typically last?
Explanation

Subscription duration is calculated using:

DATEDIFF(end_date, start_date)

The average duration is calculated for cancelled subscriptions by plan.

Business Insight

This helps determine whether cancellations tend to occur earlier or later in the subscription lifecycle.

Q4. Which subscription plans have the highest cancellation rates?
Explanation

Cancellation rate is calculated as:

Cancelled Subscriptions
÷
Total Subscriptions
× 100
Why use cancellation rate?

Cancellation counts alone can be misleading because subscription plans have different numbers of subscriptions.

Business Insight

Cancellation rate provides a more comparable measure of cancellation risk across plans.

Q5. Does auto-renewal status differ in cancellation rate?
Explanation

Subscriptions are grouped by auto_renew and cancellation rates are compared.

Business Insight

This identifies whether cancellation rates differ between subscriptions with different renewal settings.

Important Interpretation

This is an observational association.

The result should not be interpreted as proof that auto-renewal causes or prevents cancellation.

Q6. Which acquisition channels have the highest subscription cancellation rates?
Explanation

The users table is joined with subscriptions.

Cancellation rates are calculated for each acquisition channel.

Business Insight

This identifies acquisition sources associated with different subscription cancellation patterns.

Important Interpretation

An association in this dataset does not necessarily imply a causal relationship.

Q7. Within each acquisition channel, which subscription plan has the highest cancellation rate?
Explanation

The query:

Calculates cancellation rates by acquisition channel and plan.
Uses a CTE.
Applies RANK().
Partitions the ranking by acquisition channel.
Returns the highest-ranked plan.
SQL Techniques
CTE
Conditional aggregation
RANK()
PARTITION BY
Business Insight

This provides a more detailed view of cancellation risk by combining acquisition source and subscription plan.

⚠️ Churn Definition

This project measures subscription-record cancellation, not unique-user churn.

A user can have multiple subscription records.

Therefore, cancellation counts should not automatically be interpreted as the number of unique customers who churned.

## 🟡 07 — Advanced SQL / Product Analytics

SQL File: SQL/07_advanced_product_analytics.sql

This section demonstrates advanced SQL techniques used for product and business analytics.

Q1. What does cumulative revenue look like month over month?
Explanation

Monthly successful payment revenue is calculated first.

A window function then calculates cumulative revenue:

SUM(revenue) OVER (ORDER BY payment_month)
SQL Technique

Running total using a window function

Business Insight

Cumulative revenue shows how recorded successful payment revenue builds over time.

Q2. If users are split into four equal-sized engagement tiers by total watch time, how does each tier compare?
Explanation

Users are first aggregated by total watch time.

NTILE(4) then divides users into four approximately equal-sized engagement groups.

The analysis compares:

Users per tier
Average sessions
Average watch minutes
Average completion percentage
SQL Technique

NTILE segmentation

Business Insight

This creates practical engagement segments ranging from lower to higher engagement.

These segments can support:

User segmentation
Personalization
Retention strategies
Engagement analysis
Q3. Which operating systems have the highest viewing activity and completion?
Explanation

The devices table is joined with viewing_sessions.

Operating systems are compared using:

Total sessions
Unique users
Total watch time
Average completion percentage
Business Insight

This identifies operating-system-level differences in viewing behaviour.

Q4. Which genres rank highest by completion rate?
Explanation

Genre performance is calculated first.

A minimum sample size of 1,000 sessions is enforced.

Genres are then ranked using:

RANK() OVER (
    ORDER BY avg_completion_pct DESC
)
Why use a sample-size threshold?

A genre with very few sessions could have an unstable average completion rate.

The threshold makes the ranking more meaningful.

SQL Techniques
CTE
Aggregation
RANK()
Window functions
Business Insight

This provides a more reliable ranking of genres based on completion behaviour.

Q5. Within each plan, who are the most engaged active subscribers?
Explanation

The query performs several analytical steps:

Identifies active subscribers.
Calculates user-level engagement.
Filters users with at least 20 sessions.
Ranks users within each subscription plan.
Returns the top 10 users per plan.
SQL Techniques
Multiple CTEs
DISTINCT
Aggregation
RANK()
PARTITION BY
Business Insight

This connects subscription information with actual user behaviour and identifies highly engaged users within each active subscription plan.

🧠 SQL Skills Demonstrated

SQL Skill	Example Use
SELECT	Data retrieval
WHERE	Filtering
GROUP BY	Segmentation
HAVING	Sample-size filtering
ORDER BY	Ranking
JOIN	Multi-table analysis
LEFT JOIN	Unwatched content
CASE	Conditional calculations
Subqueries	Percentage calculations
CTEs	Retention, churn and advanced analysis
RANK()	Ranking within groups
LAG()	Month-over-month comparison
NTILE()	Engagement segmentation
Window Functions	Running totals and analytical calculations
Date Functions	Monthly trends and retention windows

📌 Key Portfolio Takeaways
👥 User Base

10,000 registered users
Users are distributed across multiple countries, languages and age groups.
Organic Search is the largest acquisition channel with 2,810 users.

🎬 Engagement

200,000 viewing sessions
124,200 completed sessions
Viewing behaviour can be analyzed across discovery sources, devices and video quality.

🎞️ Content

2,000 content titles
1,233 Movies
767 Series
15 genres
Content-to-genre relationships are handled using a bridge table.

💳 Subscriptions

11,455 subscription records
6,177 Active
2,668 Cancelled
2,610 Expired
Standard has the largest number of subscription records with 3,579.

💰 Payments

60,000 payment records
55,791 Successful
4,209 Failed
UPI is the most frequently recorded payment method with 25,174 records.

📈 Retention

30-day retention
60-day retention
90-day retention
Cohort-based retention
Acquisition-channel retention
Age-group retention

🔄 Churn

Subscription cancellation trends
Cancellation rates by plan
Cancellation rates by auto-renewal status
Cancellation rates by acquisition channel
Plan-level cancellation ranking within acquisition channels
🧠 Advanced Analytics
CTEs
Window functions
Running totals
RANK()
LAG()
NTILE()
User engagement segmentation
Subscriber engagement analysis

⚠️ Data Caveats & Honest Interpretation

This project documents its assumptions and limitations because analytical conclusions should always consider data quality and dataset design.
Synthetic Dataset
StreamIQ is a fictional dataset created for portfolio analysis.
It does not represent real company data.
Payment History
The dataset contains 60,000 payment records.
This should be treated as available/capped payment history rather than a complete financial ledger.
Viewing Sessions
Viewing sessions are synthetically generated and are not constrained to active subscription periods.
Therefore, viewing activity should not automatically be interpreted as paid-subscriber activity.

Retention

Retention measures viewing engagement after signup rather than subscription renewal.

Churn

Churn analysis is based on subscription records rather than unique users.

MRR

MRR represents an active-subscription MRR proxy.

ARPU

ARPU represents average revenue per paying user across the available payment history, not monthly ARPU.

Completion Percentage

Completion percentage is based on watch minutes relative to content runtime and is capped at 100%.

session_status is independently generated.

Therefore, a session marked Completed does not necessarily mean exactly 100% completion.

🚀 Project Workflow
Relational Dataset
        ↓
Understand Tables & Relationships
        ↓
Define Business Questions
        ↓
Write SQL Queries
        ↓
Join & Aggregate Data
        ↓
Apply Advanced SQL
        ↓
Interpret Results
        ↓
Identify Business Opportunities

🎯 Project Outcome

StreamIQ demonstrates an end-to-end SQL analytics workflow:

Business Questions → SQL → Analysis → Interpretation → Business Value

The project focuses not only on writing SQL syntax, but also on understanding how relational data can be transformed into meaningful analytical insights.

👨‍💻 Project Information

Project: StreamIQ — Streaming Platform SQL Analytics
Database: MySQL
Tool: MySQL Workbench
Dataset: Synthetic / Fictional
Focus: Data Analyst Portfolio Project

⭐ Final Note

This project demonstrates how a Data Analyst can move from:

Business Questions → SQL Analysis → Insights → Business Interpretation

rather than treating SQL as a collection of isolated coding exercises.
