# DevOps Assessment – Terraform & Database Reliability

## Overview

This project demonstrates Infrastructure as Code (IaC), database management, and DevOps best practices by provisioning AWS infrastructure using Terraform and implementing database backup, restore, and query optimization using MySQL and Docker Compose.

The solution includes:

* Modular Terraform infrastructure
* Separate Dev and Prod environments
* MySQL database using Docker Compose
* Database schema and seed data
* Query optimization using indexes
* Automated backup and restore scripts
* GitHub Actions workflow for Terraform validation

---

# Architecture

```
                    Internet
                        │
                        ▼
                Application Load Balancer
                        │
                        ▼
                 ECS / Fargate Service
                        │
                        ▼
                 Private MySQL RDS
```

---

# Project Structure

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── app/
│
├── backups/
│
├── database/
│   ├── docker-compose.yml
│   ├── .env.example
│   ├── migrations/
│   └── seeds/
│
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   ├── security/
│   │   ├── ecs/
│   │   └── rds/
│   │
│   └── envs/
│       ├── dev/
│       └── prod/
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── README.md
└── .gitignore
```

---

# Technologies Used

* Terraform
* AWS (VPC, ALB, ECS/Fargate, RDS)
* Docker Compose
* MySQL 8
* GitHub Actions
* Shell Scripting

---

# Infrastructure

Terraform provisions the following AWS resources:

* VPC
* Public & Private Subnets
* Internet Gateway
* Route Tables
* Security Groups
* Application Load Balancer
* ECS Cluster
* ECS Task Definition
* ECS Service
* Private MySQL RDS Instance

Infrastructure is organized into reusable modules.

---

# Environment Configuration

Separate Terraform environments are maintained for:

## Development

* Smaller RDS instance
* Backup retention: 1 day
* Deletion protection: Disabled

## Production

* Larger RDS instance
* Longer backup retention
* Deletion protection: Enabled

Each environment has its own:

* variables
* terraform.tfvars
* backend configuration

---

# Terraform Commands

Initialize Terraform

```bash
terraform init
```

Validate

```bash
terraform validate
```

Format

```bash
terraform fmt
```

Plan

```bash
terraform plan -refresh=false
```

---

# Local Database Setup

Navigate to the database directory.

```bash
cd database
```

Start MySQL

```bash
docker compose up -d
```

Verify containers

```bash
docker ps
```

---

# Database Schema

The project contains two tables:

* hotel_bookings
* booking_events

Database initialization is handled automatically using Docker Compose.

---

# Seed Data

The project inserts:

* 100+ Hotel Bookings
* Multiple Organizations
* Multiple Cities
* Multiple Booking Statuses
* Booking Events

---

# Query Optimization

The following query was optimized:

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city='delhi'
AND created_at >= NOW() - INTERVAL 30 DAY
GROUP BY org_id,status;
```

Indexes added:

```
(city, created_at)
(org_id, status)
```

### Why these indexes?

The composite index on `(city, created_at)` improves filtering performance for the `WHERE` clause by allowing MySQL to efficiently locate rows matching both the city and date range.

The `(org_id, status)` index supports grouping and aggregation by reducing the amount of data MySQL needs to process during the `GROUP BY` operation.

---

# Backup

Run:

```bash
./scripts/backup.sh
```

The script creates a timestamped SQL dump inside the `backups/` directory.

Example:

```
backups/hoteldb_20260708_143252.sql
```

---

# Restore

Restore a backup:

```bash
./scripts/restore.sh backups/<backup-file>.sql
```

---

# Verifying Restore

1. Delete all records from both tables.

```sql
DELETE FROM booking_events;
DELETE FROM hotel_bookings;
```

2. Execute the restore script.

```bash
./scripts/restore.sh backups/<backup-file>.sql
```

3. Verify the restored data.

```sql
SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

If the original record counts are restored, the restore operation is successful.

---

# GitHub Actions

A GitHub Actions workflow is included that automatically executes on every push and pull request.

The workflow performs:

* Terraform Format Check
* Terraform Init
* Terraform Validate
* Terraform Plan

AWS credentials are securely managed using GitHub Secrets.

---

# Security

Sensitive values such as the database password are not committed to the repository.

The CI workflow injects secrets using GitHub Actions Secrets.

---

# Assumptions

* AWS deployment is intended for infrastructure validation and planning only.
* Local Docker Compose is used for database testing.
* The project uses MySQL 8.
* Terraform state is maintained separately for Development and Production environments.

---

# Future Improvements

* Remote Terraform Backend (Amazon S3 + DynamoDB)
* ECS Application Deployment
* Automatic Database Migration Pipeline
* Monitoring using CloudWatch and Prometheus
* Automated Database Backup Scheduling
* Multi-AZ RDS Deployment
* Terraform Cost Optimization
