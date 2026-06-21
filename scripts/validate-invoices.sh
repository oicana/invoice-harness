#!/usr/bin/env bash
# Compile every sample invoice and validate the
# resulting hybrid PDF/A-3b with the Mustangproject CLI.

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

typst="${TYPST:-$repo_root/../typst/target/release/typst}"
mustang_jar="${MUSTANG_JAR:-$repo_root/tools/Mustang-CLI.jar}"
invoices_dir="$repo_root/tests/invoices"
out_dir="$repo_root/out"

fail() { echo "error: $*" >&2; exit 1; }

[[ -x "$typst" ]] || command -v "$typst" >/dev/null 2>&1 \
  || fail "typst binary not found or not executable: $typst (set TYPST)"
[[ -f "$mustang_jar" ]] \
  || fail "Mustang jar not found: $mustang_jar (run scripts/fetch-mustang.sh)"
command -v java >/dev/null 2>&1 || fail "java not found on PATH (need JDK 17+)"
[[ -d "$invoices_dir" ]] || fail "no sample invoices at $invoices_dir"

echo "typst:   $("$typst" --version)"
echo "mustang: $(readlink -f "$mustang_jar" 2>/dev/null || echo "$mustang_jar")"
echo

mkdir -p "$out_dir"

declare -a passed=() failed=()

for dir in "$invoices_dir"/*/; do
  profile="$(basename "$dir")"
  src="$dir/invoice.typ"
  [[ -f "$src" ]] || { echo "skip $profile (no invoice.typ)"; continue; }

  pdf="$out_dir/$profile.pdf"
  report="$out_dir/$profile.report.xml"
  echo "=== $profile ==="

  if ! "$typst" compile --pdf-standard a-3b --root "$repo_root" "$src" "$pdf"; then
    echo "  compile FAILED"
    failed+=("$profile")
    continue
  fi

  # Mustang prints an XML report to stdout and exits non-zero when invalid.
  if java -jar "$mustang_jar" --action validate --source "$pdf" >"$report" 2>&1 \
     && grep -q 'status="valid"' "$report"; then
    echo "  validation PASSED"
    passed+=("$profile")
  else
    echo "  validation FAILED (see $report)"
    grep -o 'summary status="[^"]*"\|<message[^>]*>[^<]*</message>' "$report" | head -n 20 | sed 's/^/    /'
    failed+=("$profile")
  fi
done

echo
echo "passed: ${#passed[@]} (${passed[*]:-})"
echo "failed: ${#failed[@]} (${failed[*]:-})"
[[ ${#failed[@]} -eq 0 ]]
