-- First-volume init only (docker-entrypoint-initdb.d). MariaDB 10.11.
-- MYSQL_USER already creates 'bigcapital' with rights on MYSQL_DATABASE only.
-- Tenant schemas need CREATE DATABASE on *.*, same as upstream init.sql.
CREATE USER IF NOT EXISTS 'bigcapital'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'bigcapital'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
