#!/usr/bin/env bash
# 開発リポ(my-company/.company/education/toshin/superelite/_slides/v3)から
# 配布リポへ 4 デッキと資産を再同期する。
#
# 使い方: ./sync_from_dev.sh
#
# 開発側で編集 → 本スクリプト → git add/commit/push の流れで反映する。
# 配布リポは GitHub Pages で即時公開されるため、本番前は必ず http で実機検証。

set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEV="/Users/mikiokofune/my-company/.company/education/toshin/superelite/_slides/v3"
DEV_TOOLS="/Users/mikiokofune/my-company/.company/education/toshin/superelite/_tools"

if [[ ! -d "$DEV" ]]; then
  echo "ERROR: dev source not found: $DEV" >&2
  exit 1
fi

echo "[1/3] decks"
cp "$DEV/00-act0-opening.html"        "$ROOT/act0/index.html"
cp "$DEV/01-act1-four-worlds.html"    "$ROOT/act1/index.html"
cp "$DEV/03b-act3-transformer.html"   "$ROOT/act3a/index.html"
cp "$DEV/03c-act3-diffusion.html"     "$ROOT/act3b/index.html"

echo "[2/3] _tools / _assets"
rm -rf "$ROOT/_tools"
cp -R "$DEV_TOOLS" "$ROOT/_tools"
find "$ROOT/_tools" -name ".DS_Store" -delete
cp "$DEV/_assets/atlas_higgs_real.png" "$ROOT/_assets/atlas_higgs_real.png"

echo "[3/3] patch act0 paths (../../_tools/ -> ../_tools/)"
sed -i.bak 's|\.\./\.\./_tools/|../_tools/|g' "$ROOT/act0/index.html"
rm -f "$ROOT/act0/index.html.bak"

echo "OK. diff: "
( cd "$ROOT" && git status --short )
