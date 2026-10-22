#!/usr/bin/env bash
# Testa a migração e as políticas RLS num PostgreSQL local (sem Supabase).
# Uso: npm run test:db   (requer psql e um usuário com permissão de criar bancos)
# Variáveis opcionais: PSQL="sudo -u postgres psql"  DB=folkara_test
set -euo pipefail
cd "$(dirname "$0")/.."
PSQL=${PSQL:-psql}
DB=${DB:-folkara_test}
$PSQL -q -d postgres -c "drop database if exists $DB" -c "create database $DB"
cat tests/00_supabase_shim.sql migrations/*.sql tests/*_tests.sql | $PSQL -q -v ON_ERROR_STOP=1 -d "$DB"
