# CLAUDE.md

AI コーディングアシスタント（Claude Code 等）と人間のコントリビュータ向けガイドライン。
本ファイルは**要約とポインタのみ**を置く。実体は §2 の各正本にある。

## 1. Project Overview

<!-- TODO: プロダクト名と一行説明。詳細は docs/PRD.md に書き、ここには要約のみを置く -->

## 2. Documents（正本の所在）

| 知りたいこと | 正本 |
|---|---|
| なぜ・何を（要件） | [docs/PRD.md](docs/PRD.md) |
| 全体構成・不変条件 | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| 用語（ユビキタス言語） | [docs/UBIQUITOUS_LANGUAGE.md](docs/UBIQUITOUS_LANGUAGE.md) |
| 開発フローの定義 | [docs/WORKFLOW.md](docs/WORKFLOW.md) |
| Epic ごとの詳細設計 | `docs/design/epic-NN-*.md` |
| 個別の設計判断 | [docs/adr/](docs/adr/README.md) |

## 3. Tech Stack

<!-- TODO: 言語 / パッケージ管理 / lint / テストランナーを書く（例: uv / ruff / pytest） -->

## 4. Development Workflow

GitHub issue 駆動の2階層。定義の正本は [docs/WORKFLOW.md](docs/WORKFLOW.md)。

- **Epic**（`type:epic`）: DesignDoc（`docs/design/epic-NN-<topic>.md`）を必ず伴う開発単位。
  背景・ユーザーストーリー・AC の正本は DesignDoc。issue には要約とリンクだけを書く。
- **Story**（`type:story`）: 動作確認可能な最小単位。0.5–3日、扱う Acceptance Criteria は5個以下。
- 流れ: Epic 起票 → DesignDoc 初版（Background・User Stories・構成図・**ドメインモデル図**・
  **シーケンス図**）→
  Story 分割 → 実装のたびに DesignDoc を詳細化（Decisions / Story Timeline / Test Design Matrix）。
- ブランチはトランクベース + Epic stacking。Epic は `epic/<issue番号>-<slug>`、
  Story は既定で Epic ブランチに直接コミット。
- Test Design Matrix 全✓ が Epic PR のレビューゲート。
- **AI アシスタントは Epic PR を `main` にマージしない**。人間がレビューしてマージする。

## 5. ADR ハードルール

実装中に計画外の設計判断が出たら、PR マージ前に必ず次のいずれかを行う
（詳細: [docs/WORKFLOW.md §6](docs/WORKFLOW.md)）。

1. ADR を作る（既定。`docs/adr/NNNN-<slug>.md`）。
2. Epic の DesignDoc `## Decisions` に書く（効果がその Epic を超えない場合のみ）。
3. PR 説明に明記して人間に確認する（1 も 2 も過剰な小さい判断のみ）。

黙って判断して先へ進むことを禁止する。

## 6. Coding Principles（ハードルール）

正本: [.claude/rules/coding-principles.md](.claude/rules/coding-principles.md)

- YAGNI: 今必要でない機能・抽象を先回りで作らない。共通化は Rule of Three。
- TDD（t-wada 流）: Red → Green → Refactor を小さく回す。テストリストを作り、
  仮実装 → 三角測量 → 明白な実装の順で一般化する。テストコードが正（仕様）。

## 7. Rules and Templates

- [.claude/rules/coding-principles.md](.claude/rules/coding-principles.md)
- [.claude/rules/adr-template.md](.claude/rules/adr-template.md)
- [.claude/rules/design-doc-template.md](.claude/rules/design-doc-template.md)

## 8. Language

<!-- TODO: プロジェクト固有の言語ルールを足す（例: 応答は日本語、コード・フィールド名は英語） -->

- 文書・コード・テスト・図は [docs/UBIQUITOUS_LANGUAGE.md](docs/UBIQUITOUS_LANGUAGE.md)
  の語だけを使う。書く前に読み、表にない概念は同じ PR で足す（[docs/WORKFLOW.md §7](docs/WORKFLOW.md)）。
- 日本語の文書は `yomiyasu:yomiyasu` スキルで推敲する。対象・タイミング・文書の種類は
  [docs/WORKFLOW.md §8](docs/WORKFLOW.md) に従う。
- 節名は英語のまま。日常的に使われる語や専門用語も英語でよく、推敲でも訳さない。
