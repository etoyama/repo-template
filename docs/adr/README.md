# Architecture Decision Records

cross-epic な設計判断・長期制約・`docs/ARCHITECTURE.md` への変更を記録する。
新規は [.claude/rules/adr-template.md](../../.claude/rules/adr-template.md) をコピーし、
確定後この索引に追記する。1ファイル1決定、`NNNN` は4桁ゼロ詰め連番。

Epic 内で完結する決定は ADR にせず、その Epic の Design Doc の `## Decisions` に置く
（使い分けの正本: [docs/WORKFLOW.md §6](../WORKFLOW.md)）。

| ADR | Title | Status |
|---|---|---|
| [0001](0001-designdoc-owns-requirements.md) | 要求と背景の正本を DesignDoc に置く | Accepted |
| [0002](0002-ubiquitous-language.md) | ユビキタス言語の正本を置き、コード・テスト・図をその語で書く | Accepted |
| [0003](0003-yomiyasu-for-japanese-docs.md) | 日本語の文書を yomiyasu で推敲する | Accepted |
| [0004](0004-decision-analysis-plugin.md) | 判断の提示と ADR を Decision Analysis の形式にそろえる | Accepted |
| [0005](0005-designdoc-draft-checks-whole-and-mockup.md) | DesignDoc 初版では、全体の整合を確かめ、成果物の見本を見せてから承認を求める | Accepted |
| [0006](0006-pm-session-and-board.md) | Epic は PM セッションが段取りボードで統括し、作業は子セッションに渡す | Accepted |
| [0007](0007-story-done-includes-release-note-and-bug-review.md) | Story の完了の条件に、リリースノートの行と、バグ・セキュリティの観点のレビューを入れる | Accepted |
| [0008](0008-ask-before-narrowing-what-worked.md) | 今まで動いていたものを動かなくする判断は、Decisions に書くだけでなく人間に聞く | Accepted |
| [0009](0009-designdoc-decisions-scope-first.md) | DesignDoc 初版では、成果物の単位と範囲の判断を先に聞き、中身で迷ったら見本を見比べてから決める | Accepted |
| [0010](0010-retrospective-after-epic.md) | Epic のリリースの後に、軽量な定型の振り返りを回す | Accepted |
