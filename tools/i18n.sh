#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

MODE="${1:-all}"
AUTH_MODE="${AUTH_MODE:-auto}"
LOCALE="${LOCALE:-en}"
EN_PATH="${EN_PATH:-assets/i18n/en.json}"
I18N_TRANSLATOR_MANIFEST="${I18N_TRANSLATOR_MANIFEST:-../greentic-i18n/Cargo.toml}"

usage() {
  cat <<'USAGE'
Usage: tools/i18n.sh [translate|validate|status|all]
USAGE
}

run_translate() {
  cargo run --manifest-path "$I18N_TRANSLATOR_MANIFEST" -p greentic-i18n-translator -- \
    --locale "$LOCALE" \
    translate --langs all --en "$EN_PATH" --auth-mode "$AUTH_MODE"
}

run_validate() {
  cargo run --manifest-path "$I18N_TRANSLATOR_MANIFEST" -p greentic-i18n-translator -- \
    --locale "$LOCALE" \
    validate --langs all --en "$EN_PATH"
}

run_status() {
  cargo run --manifest-path "$I18N_TRANSLATOR_MANIFEST" -p greentic-i18n-translator -- \
    --locale "$LOCALE" \
    status --langs all --en "$EN_PATH"
}

case "$MODE" in
  translate) run_translate ;;
  validate) run_validate ;;
  status) run_status ;;
  all) run_translate; run_validate; run_status ;;
  *) usage; exit 2 ;;
esac
