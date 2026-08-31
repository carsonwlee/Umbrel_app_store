-- Runs only on first MariaDB volume init (docker-entrypoint-initdb.d).
-- The official image already creates MYSQL_USER (bigcapital) with rights on
-- MYSQL_DATABASE. Tenant DBs need CREATE DATABASE, matching upstream:
-- GRANT ALL PRIVILEGES ON *.* TO '{user}'@'%' ... WITH GRANT OPTION.
GRANT ALL PRIVILEGES ON *.* TO 'bigcapital'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
