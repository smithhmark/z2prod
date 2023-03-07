set allow-duplicate-recipes

DB_HOST := env_var_or_default("POSTGRES_HOST", "127.0.0.1")
DB_USER := env_var_or_default("POSTGRES_USER", "postgres")
DB_PASSWORD := env_var_or_default("POSTGRES_PASSWORD", "password")
DB_NAME := env_var_or_default("POSTGRES_DB", "newsletter")
DB_PORT := env_var_or_default("POSTGRES_PORT", "5432")

default:
    just --list

# turns on source change detection
watch:
    cargo watch -x check -x test -x run

# expand macros to see what is going on with Rust macro invocations
expand *ARGS:
    cargo +nightly expand {{ARGS}}

# scan dependencies for security vunerabilities
audit:
    cargo audit

# measure test coverage
coverage:
    cargo tarpaulin --ignore-tests

test:
    cargo test

db-up:
    @docker compose up -d postgres

[windows]
db-up:
    @docker.exe compose up -d postgres adminer

db-down:
    @docker compose down postgres adminer

[windows]
db-down:
    @docker.exe compose down postgres

init-db: db-up
    init_db.sh

[windows]
new-migration migname:
    #! sh
    echo "new-migration"
    DB_URL="postgres://{{DB_USER}}:{{DB_PASSWORD}}@{{DB_HOST}}:{{DB_PORT}}/{{DB_NAME}}"
    sqlx.exe migrate add {{migname}}