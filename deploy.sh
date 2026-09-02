#!/usr/bin/env bash
# Deploy the map to Cloudflare Pages.
# First run: `npx wrangler login` (click Allow in the browser), then this script.
set -euo pipefail
cd "$(dirname "$0")"

PROJECT=latino-sydney

if ! npx wrangler whoami >/dev/null 2>&1; then
  echo "Not logged in — running wrangler login (approve in browser)…"
  npx wrangler login
fi

npx wrangler pages project list 2>/dev/null | grep -q "$PROJECT" || \
  npx wrangler pages project create "$PROJECT" --production-branch main

npx wrangler pages deploy site --project-name "$PROJECT" --commit-dirty=true
echo
echo "Live at: https://$PROJECT.pages.dev"
