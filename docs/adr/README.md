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
| [0011](0011-start-wave-one-before-designdoc-approval.md) | 波 1 の子は、DesignDoc 初版の子を立てるターンで、待機の指示で立てておく | Accepted |
| [0012](0012-shared-notes-in-app-folder-checked-by-path.md) | 共有ノートはアプリの置き場に置き、子が報告した絶対パスを PM が確かめてボードに残す | Accepted |
| [0013](0013-write-rules-reasons-and-helpers-into-designdoc-and-brief.md) | DesignDoc とブリーフには、守りたい規則、触らない理由、使う既存の道具を書く | Accepted |
| [0014](0014-start-all-waves-in-first-human-turn.md) | 後に続く波の子は、最初に子を立てる人間のターンで、全部待機の指示で立てておく | Accepted |
| [0015](0015-copy-pm-address-from-listagents.md) | ブリーフに書く PM の宛先は ListAgents から写し、PM のシステムプロンプトの宛先と置き場は写さない | Accepted |
| [0016](0016-try-with-real-data-before-epic-pr.md) | 利用者が触る Epic では、ゲートの後、Epic PR の前に、実データで使ってみる | Accepted |
| [0017](0017-try-before-asking-human.md) | 人間に判断を仰ぐ前に、30分以内に試せることは試し、結果を添えて聞く | Accepted |
| [0018](0018-check-proposals-against-real-artifact.md) | 子セッションやレビューが出した案は、PM が実物と照らしてから人間に渡す | Accepted |
| [0019](0019-human-reads-real-screen-after-first-display-story.md) | 利用者が読む画面を変える Epic では、画面を初めて変える Story の後に、人間が実物の画面と言い回しの一覧を読む | Accepted |
| [0020](0020-recheck-whole-after-mockup-comments.md) | DesignDoc 初版で、見本へのコメントを反映した後に、全体の整合をもう一度回す | Accepted |
| [0021](0021-verify-premises-in-production-shape.md) | 前提を確かめる見本と検証用のものは、本番と同じ形で作る | Accepted |
| [0022](0022-unattended-run-done-after-one-unattended-pass.md) | 無人の実行は、Run now の後に、本番の時刻の1回を無人で通してから完了にする | Accepted |
| [0023](0023-measure-shared-checkout-settings-before-recommending.md) | 共有の checkout の設定を変える案は、効く範囲を書き、使い捨ての場で測ってから推奨する | Accepted |
| [0024](0024-copy-counts-and-ids-from-command-output.md) | ブリーフと PR の説明に書く数と id は、コマンドやツールの結果から写す | Accepted |
