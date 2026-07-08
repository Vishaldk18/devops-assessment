# Database Setup

This directory contains the local MySQL database setup used for testing backup, restore, and query optimization.

## Contents

* `docker-compose.yml` – Starts the MySQL container.
* `.env.example` – Example environment variables.
* `migrations/` – Database schema creation scripts.
* `seeds/` – Seed data for hotel bookings and booking events.

## Start the Database

```bash
docker compose up -d
```

## Verify the Container

```bash
docker ps
```

## Connect to MySQL

```bash
docker exec -it hotel-booking-db mysql -uadmin -padmin123 hoteldb
```

## Backup

```bash
./scripts/backup.sh
```

## Restore

```bash
./scripts/restore.sh backups/<backup-file>.sql
```

For complete project setup and Terraform instructions, refer to the repository's root `README.md`.
