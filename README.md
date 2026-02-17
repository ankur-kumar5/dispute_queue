# Dispute Review Queue (Rails 8)

A dispute management system built with Rails 8 that simulates payment
processor dispute workflows.
It supports webhook ingestion, evidence submission, admin decisioning,
and reporting.

------------------------------------------------------------------------

## Features

### Webhook Processing

-   Accepts dispute events via `/webhooks/disputes`
-   Handles:
    -   `dispute.opened`
    -   `dispute.closed`
-   Idempotency support via `WebhookEvent`
-   Background processing using Sidekiq

------------------------------------------------------------------------

### Admin Dispute Review

-   Admin dashboard under `/admin`
-   View dispute queue
-   View dispute details
-   Add multiple evidences
-   Decide dispute outcome (Won / Lost)

------------------------------------------------------------------------

### Evidence Management

-   Dispute has many evidences
-   Evidence types:
    -   receipt
    -   customer_communication
    -   shipping_proof
-   After adding evidence → status becomes `awaiting_decision`

------------------------------------------------------------------------

### Reporting

#### Daily Volume

-   Grouped by day
-   Filter by `from` and `to` date
-   Shows:
    -   Total disputes
    -   Total amount

#### Time To Decision (Weekly)

-   Includes only `won` / `lost` disputes
-   Calculates duration: `closed_at - opened_at`
-   Uses PostgreSQL percentiles:
    -   p50
    -   p90
-   Grouped by week

------------------------------------------------------------------------

## 🏗 Architecture Overview

### Domain Models

-   User
-   Charge
-   Dispute
-   Evidence
-   CaseAction (Audit Log)
-   WebhookEvent

------------------------------------------------------------------------

### Relationships

-   Charge has_many :disputes
-   Dispute belongs_to :charge
-   Dispute has_many :evidences
-   Dispute has_many :case_actions

------------------------------------------------------------------------

## Authentication & RBAC

-   Uses Rails 8 built-in authentication
-   Role-based access control (RBAC)
-   Roles:
    -   admin
    -   reviewer
    - read_only

Admin namespace restricted via `Admin::BaseController`.

------------------------------------------------------------------------

## Dispute Lifecycle

Webhook: dispute.opened
↓
Status: open
↓
Admin adds evidence
↓
Status: awaiting_decision
↓
Admin decides
↓
Status: won OR lost

------------------------------------------------------------------------

##  Tech Stack
-   Ruby 3.4
-   Rails 8
-   PostgreSQL
-   Sidekiq
-   Redis

------------------------------------------------------------------------

## Setup Instructions

### 1. Clone Repository

    git clone git@github.com:ankur-kumar5/dispute_queue.gi
    cd dispute_queue

### 2. Install Dependencies

    bundle install

### 3. Setup Database

    rails db:create
    rails db:migrate
    rake users:create_demo

### 4. Start Redis

    redis-server

### 5. Start Sidekiq

    bundle exec sidekiq

### 6. Start Rails Server

    rails server

App runs on: http://localhost:3000

------------------------------------------------------------------------

## Create Admin User

Open console:

    rails console

Access admin panel:

`/admin/disputes`

------------------------------------------------------------------------

## Testing Webhooks

### Dispute Opened

    curl -X POST http://localhost:3000/webhooks/disputes   -H "Content-Type: application/json"   -d '{
        "event_id": "evt_1001",
        "event_type": "dispute.opened",
        "occurred_at": "2026-02-17T10:00:00Z",
        "charge_external_id": "ch_123",
        "dispute_external_id": "dp_123",
        "amount_cents": 10000,
        "currency": "USD",
        "status": "open"
      }'

### Dispute Closed

    curl -X POST http://localhost:3000/webhooks/disputes   -H "Content-Type: application/json"   -d '{
        "event_id": "evt_1002",
        "event_type": "dispute.closed",
        "dispute_external_id": "dp_123",
        "status": "won",
        "occurred_at": "2026-02-20T10:00:00Z"
      }'

------------------------------------------------------------------------

## Reporting URLs

-   `/admin/reports/daily_volume`
-   `/admin/reports/time_to_decision`

------------------------------------------------------------------------

## Security Notes

-   Webhooks skip authentication but should validate secret headers
-   Admin namespace protected by role check
-   Strong parameters used in controllers

------------------------------------------------------------------------

## Project Status

✔ Webhook ingestion
✔ Dispute lifecycle
✔ Evidence submission
✔ Admin decisioning
✔ Reporting
✔ RBAC
✔ Background jobs

------------------------------------------------------------------------

## Folder Structure Overview

    app/
      controllers/
        admin/
        webhooks/
      models/
      jobs/
      views/
      assets/stylesheets/admin.css

------------------------------------------------------------------------

