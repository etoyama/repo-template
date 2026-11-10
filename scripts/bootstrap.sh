#!/usr/bin/env bash
# GitHub 側の設定（ファイルとして運べないもの）を作成する。冪等。
# 前提: gh CLI が認証済みで、カレントディレクトリが対象リポジトリのルートであること。
# 使い方: ./scripts/bootstrap.sh
set -euo pipefail

create_label() {
  # --force: 既存なら色・説明を更新（再実行しても安全）
  gh label create "$1" --color "$2" --description "$3" --force
}

create_label "type:epic"  "5319E7" "Epic: DesignDoc を伴う開発単位"
create_label "type:story" "0E8A16" "Story: 動作確認可能な最小単位（0.5-3日・AC5個以下）"

echo "bootstrap done: labels type:epic / type:story"

# yomiyasu（日本語の推敲スキル、docs/adr/0003）は Claude Code のプラグインなので、
# このスクリプトからは入れられない。導入手順を案内する。
cat <<'MSG'

next: 日本語の推敲に yomiyasu を使う（docs/WORKFLOW.md §8）。Claude Code で次を実行する:
  /plugin marketplace add nanaism/yomiyasu
  /plugin install yomiyasu@yomiyasu
MSG
