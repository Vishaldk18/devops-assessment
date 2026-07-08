CREATE DATABASE IF NOT EXISTS hoteldb;

USE hoteldb;

SOURCE /docker-entrypoint-initdb.d/001_create_tables.sql;