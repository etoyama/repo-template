# ADR-0023: 共有の checkout の設定を変える案は、効く範囲を書き、使い捨ての場で測ってから推奨する

## Status

Accepted

## Context

PM セッション（[ADR-0006](0006-pm-session-and-board.md)）では、PM も子も `main` の checkout の下の `.claude/worktrees/` にある worktree で動く。
スケジュール実行のような無人の実行は、`main` の checkout を作業フォルダにすることがある。
`main` の checkout の設定（`.claude/settings.local.json` など）を変える案を、どう確かめてから人間に出すかの決まりは無い。

このテンプレートの派生先 etoyama/knowledge-enhance の Epic 1（[#2](https://github.com/etoyama/knowledge-enhance/issues/2)、2026-11-27）で、
次のことが起きた。振り返り（#2 の[コメント](https://github.com/etoyama/knowledge-enhance/issues/2#issuecomment-7215229679)）と、
派生先の [PR #11](https://github.com/etoyama/knowledge-enhance/pull/11) の ADR-0016 の差分を読んで確かめた。

- Epic のゲートのレビューで、無人の実行が手順に無い道具を使える穴が挙がった。
- PM はスケジュール実行の作業フォルダ（`main` の checkout）の `.claude/settings.local.json` の `permissions.deny` に、
  7つの道具（`Write`、`Edit`、`NotebookEdit`、`Artifact`、`mcp__obsidian__*`、`Bash(git:*)`、`Bash(rm:*)`）を足す案を推奨した。
  worktree のセッションには効かないと見積もった。測ってはいなかった。人間がこの案を選んだ。
- 足した後に、次の2つが分かった。
  - `Artifact` を deny に入れると、`ArtifactData` も使えなくなった。Run now の2回がどちらも db を落とす手順で止まった。
  - deny は `main` の checkout の下の worktree のセッションにも効いた。マージの後、PM のセッションで `git` が止まった。
    子のセッションも worktree で動くので、開発ができなくなる。
- 人間が deny を全部消した。

道具の名前がどう一致するか（`Artifact` が `ArtifactData` も止めた理由）は、文書では確かめていない。上の実測だけが根拠である。

## Problem

- 課題1: 共有の checkout の設定は、その下の worktree の全セッション（PM、子）と、そこを作業フォルダにする無人の実行に効く。
  効く範囲を見積もりで書くと、人間は範囲を知らずに選ぶ。外れると、走っているセッションがまとめて止まる。
- 課題2: 道具の名前の一致のしかたは、読んでも分かりにくい。測らないと、止めるつもりのない道具が止まる。
- 課題3: 測るには、場を用意する手間がかかる。

扱わない範囲: どの道具を止めるかの中身（Epic ごとに違う）。利用者全体の設定（`~/.claude/settings.json`）。これは全部のリポジトリに効くので、人間が自分で変える。

## Decision Analysis

| # | 基準 | 区分 | 分類 | 重み（決めた人） | 出典 |
|---|---|---|---|---|---|
| M1 | 推奨する前に、案の設定で、使う道具が通るか止まるかの実測がある | Must | - | - | 課題1、課題2 |
| W1 | 人間が選ぶ前に、どのセッションに効くかを知れる | Want | 解決 | 高（人間。R3 を選んだ） | 課題1 |
| W2 | 測る間に、走っているセッションや無人の実行を止めない | Want | 費用 | 高（Claude の推測。Epic 1 で PM の `git` が止まった） | 課題1 |
| W3 | 測る場を用意する手間 | Want | 費用 | 低（Claude の推測） | 課題3 |

| Must | A. 使い捨ての場に同じ設定を置いて測り、効く範囲と結果を添えて推奨する | B. 本番の checkout で変えて測り、すぐ戻してから推奨する | C. 効く範囲を案に書くだけで、測らない | 何もしない |
|---|---|---|---|---|
| M1 | 満たす | 満たす | 満たさない | 満たさない |

| Want | A | B |
|---|---|---|
| W1 | 使い捨ての場の worktree でも測るので、効く範囲を実測で書ける | 本番の worktree で測るので、効く範囲を実測で書ける |
| W2 | 本番の checkout に触らないので、止めない | 測る間、PM、子、無人の実行が止まりうる |
| W3 | リポジトリの外に clone し、worktree を1つ作る手間がかかる | 手間は小さい |

- 差がつく基準: W2 と W3。
- 感度: W2 を低にし、W3 を高にすると B が勝つ。W2 は Claude の推測なので、人間に確かめてほしい。

| 案 | 起きうる悪い結果 | 抑え方 |
|---|---|---|
| A | 使い捨ての場が本番と違い（スケジュール実行の登録、追加の作業フォルダ）、測った結果が本番に当たらない | 本番と違う所を、確かめていない前提として案に書く |
| A | 測らなかった道具が止まる | 測った道具の一覧（`git`、子が使う道具、無人の実行の手順の道具）を案に書く |
| B | 測る間に、走っているセッションが止まる | 抑えにくい |
| C | Epic 1 と同じく、選んだ後に止まる | 抑えられない |
| 何もしない | 同上 | なし |

## Decision

A を採る。回し方の正本は pm-session §5 に置く。

- 共有の checkout の設定（`.claude/settings.local.json`、`.claude/settings.json` など）を変える案には、効く範囲を書く。
  その checkout の下の `.claude/worktrees/` の worktree の全セッションと、そこを作業フォルダにする無人の実行に効く。
- 推奨する前に、使い捨ての場で測る。リポジトリの外の一時フォルダに clone した checkout と、その下に作った worktree に同じ設定を置く。
  使う道具（`git`、子が使う道具、無人の実行の手順の道具）が通るか止まるかを、両方で確かめる。
- 推奨するときに、測った道具の一覧と結果、本番と違う所を添える。測れなかったら、測っていないことと理由を書く。

人間が R3 として選んだ（派生先の Epic 1 の振り返り、2026-11-27）。決め手は M1 と W2。

## Consequences

### Positive

- 共有の設定を変えたときに、走っているセッションがまとめて止まることを、推奨の前に防げる。
- 人間は効く範囲と実測を見て選べる。

### Negative

- 測る場を用意する手間がかかる。
- 使い捨ての場と本番の違い（スケジュール実行の登録など）で外れることは塞がない。
- 根拠は1件（Epic 1 の deny）だけである。

## Alternatives considered

- **共有の checkout の設定を変える案を出さない** — 無人の実行の権限のように、共有の checkout でしか置けない設定がある（派生先の ADR-0016）。

## Related

- [ADR-0017](0017-try-before-asking-human.md)（人間に聞く前に試す。この ADR は、推奨する案を試す場を決める）
- [ADR-0021](0021-verify-premises-in-production-shape.md)（前提を確かめるものは本番と同じ形で作る）
- [ADR-0022](0022-unattended-run-done-after-one-unattended-pass.md)（無人の実行の完了）
- 派生先の先行例: etoyama/knowledge-enhance の Epic 1（#2）の振り返り、PR #11
