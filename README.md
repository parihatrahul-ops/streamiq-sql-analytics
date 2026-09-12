# StreamIQ — Streaming Platform SQL Analytics

### User Behaviour • Content Performance • Revenue • Retention • Churn

> Portfolio Project | MySQL | SQL Analytics

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
