#!/usr/bin/env bash
# Download the latest Mustangproject CLI jar.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mustang_dir="${MUSTANG_DIR:-$repo_root/tools}"
api="https://api.github.com/repos/ZUGFeRD/mustangproject/releases/latest"

mkdir -p "$mustang_dir"

auth=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

echo "Resolving latest Mustangproject release..." >&2
release_json="$(curl -fsSL "${auth[@]}" -H "Accept: application/vnd.github+json" "$api")"

# Pick the Mustang-CLI fat jar asset (excludes -sources/-javadoc).
download_url="$(printf '%s' "$release_json" \
  | grep -o '"browser_download_url": *"[^"]*Mustang-CLI[^"]*\.jar"' \
  | grep -v -- '-sources\|-javadoc' \
  | head -n1 \
  | sed 's/.*"browser_download_url": *"\([^"]*\)"/\1/')"

if [[ -z "$download_url" ]]; then
  echo "error: could not find a Mustang-CLI jar asset in the latest release" >&2
  exit 1
fi

jar_name="$(basename "$download_url")"
echo "Latest Mustang CLI asset: $jar_name" >&2

curl -fsSL "${auth[@]}" -o "$mustang_dir/$jar_name" "$download_url"

# Maintain a stable, version-agnostic symlink for the validation script.
ln -sf "$jar_name" "$mustang_dir/Mustang-CLI.jar"

echo "$mustang_dir/Mustang-CLI.jar -> $jar_name"
