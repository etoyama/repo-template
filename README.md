# repo-template

Epic / Story / DesignDoc / ADR による Claude Code 開発フローを、新規・既存リポジトリに
配布するためのテンプレート。

## このフローは何か

要件を**動作確認可能な最小単位**（Story）に分割し、そのまとまり（Epic）ごとの DesignDoc を
開発しながら詳細化する開発フロー。こうして、AI の生成物と人間の理解とのずれを小さくする。
ADR と mermaid シーケンス図を必須要素とする。
定義の正本: [docs/WORKFLOW.md](docs/WORKFLOW.md)

## 含まれるもの

| パス | 役割 |
|---|---|
| `CLAUDE.md` | AI 向けガイドライン（要約とポインタのみ。TODO をプロジェクトに合わせて埋める） |
| `docs/WORKFLOW.md` | 開発フローの正典 |
| `docs/PRD.md` | 要件の正本テンプレート（なぜ・何を） |
| `docs/ARCHITECTURE.md` | アーキテクチャの正本テンプレート（不変条件・構成図・コンテキストマップ） |
| `docs/UBIQUITOUS_LANGUAGE.md` | 用語（ユビキタス言語）の正本テンプレート |
| `docs/adr/README.md` | ADR 索引 |
| `docs/design/` | Epic ごとの DesignDoc 置き場 |
| `.claude/rules/coding-principles.md` | コーディング原則（YAGNI / t-wada 流 TDD、必須） |
| `.claude/rules/adr-template.md` | ADR テンプレート |
| `.claude/rules/design-doc-template.md` | DesignDoc テンプレート（シーケンス図・責務表・Test Design Matrix） |
| `.github/ISSUE_TEMPLATE/epic.yml` / `story.yml` | Epic / Story の起票フォーム |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR テンプレート（DesignDoc / ADR 更新のチェック付き） |
| `scripts/bootstrap.sh` | GitHub 設定（labels）の作成。冪等 |

テックスタック非依存。スタック固有の記述（lint・テストランナー等）は CLAUDE.md の
TODO 節に各プロジェクトで書く。

## 使い方: 新規リポジトリ

1. GitHub で「Use this template」からリポジトリを作成する
2. clone して `./scripts/bootstrap.sh` を実行する（labels `type:epic` / `type:story` を作成）。
   表示される手順で yomiyasu プラグインを入れる
3. `CLAUDE.md` の TODO（Overview / Tech Stack / Language）を埋める
4. `docs/PRD.md`・`docs/ARCHITECTURE.md`・`docs/UBIQUITOUS_LANGUAGE.md` をテンプレートに沿って書く
5. この `README.md` をプロダクトの README に書き換える
6. 最初の Epic を起票してフローを開始する

## 使い方: 既存リポジトリへの移植

将来的に `/flow-adopt` スキルで自動化する予定。現状の手動手順は次のとおり。

1. 次のファイルをコピーする。
   `.claude/rules/` 一式、`.github/ISSUE_TEMPLATE/epic.yml` と `story.yml`、
   `.github/PULL_REQUEST_TEMPLATE.md`、`docs/WORKFLOW.md`、`docs/adr/README.md`、
   `docs/adr/0001`〜`0003`（このフローの決定。WORKFLOW とテンプレートが参照する）、
   `docs/design/`（空ディレクトリ）、`scripts/bootstrap.sh`
2. `docs/PRD.md` / `docs/ARCHITECTURE.md` / `docs/UBIQUITOUS_LANGUAGE.md` をテンプレートから作成する
   （既存の要件・設計文書があれば節構成に合わせて再編する）
3. 既存の `CLAUDE.md` に、本テンプレート `CLAUDE.md` の §2（正本の所在）・
   §4（Development Workflow）・§5（ADR ハードルール）・§8（Language）をマージする。
   既存の記述と重複・矛盾する箇所は既存側を整理する
4. `./scripts/bootstrap.sh` を実行する

## 背景

仕様駆動開発（全体設計 → 実装）では文書とコードが長大化し、レビューする人間の認知が
追いつかなくなった。最小単位ごとの DesignDoc に変えることで一度に精査する情報量を絞る。
配布モデルは shadcn/ui 型（コピーして所有し、適用の摩擦は道具で潰す）。
