#!/usr/bin/bash
set -x
set -eo pipefail

DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD=${POSTGRES_PASSWORD:=password}
DB_NAME=${POSTGRES_DB:=newsletter}
DB_PORT=${POSTGRES_PORT:=5432}

#read -p "Press Enter to continue" </dev/tty
#docker run \
#  -e POSTGRES_USER=${DB_USER} \
#  -e POSTGRES_PASSWORD=${DB_PASSWORD} \
#  -e POSTGRES_DB=${DB_NAME} \
#  -p "${DB_PORT}":5432 \
#  -d postgres:15 postgres -N 1000

#read -p "Press Enter to continue" </dev/tty

DB_HOST=${POSTGRES_HOST:=localhost}
until docker compose run --rm -e PGPASSWORD=${DB_PASSWORD} postgres psql -h postgres -U ${DB_USER} -p ${DB_PORT} -c '\q';
do
    sleep 1
done
DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
export DATABASE_URL

sqlx database create
sqlx migrate run