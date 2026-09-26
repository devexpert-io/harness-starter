#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Repositorio: $(pwd)"
echo "Estado del harness: pre-bootstrap"
echo "La aplicación todavía no está inicializada (stack propuesto: Next.js + PostgreSQL)."
echo "Siguiente paso: implementar la feature 'bootstrap-nextjs-app' de feature_list.json."
echo "Tras el bootstrap, sustituir este script por la variante real con:"
echo "  - instalación de dependencias"
echo "  - arranque/migración de PostgreSQL"
echo "  - verificación base (lint, typecheck, tests)"
echo "  - comando de arranque de la app"

if command -v python3 >/dev/null 2>&1; then
  python3 -m json.tool feature_list.json >/dev/null
  echo "feature_list.json: JSON válido"
fi
