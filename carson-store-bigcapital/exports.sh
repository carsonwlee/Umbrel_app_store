export APP_CARSON_STORE_BIGCAPITAL_DB_PASSWORD="$(derive_entropy "${app_entropy_identifier}-mysql-password")"
export APP_CARSON_STORE_BIGCAPITAL_DB_ROOT_PASSWORD="$(derive_entropy "${app_entropy_identifier}-mysql-root-password")"
export APP_CARSON_STORE_BIGCAPITAL_JWT_SECRET="$(derive_entropy "${app_entropy_identifier}-jwt-secret")"
