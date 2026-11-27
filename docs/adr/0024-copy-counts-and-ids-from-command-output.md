# ADR-0024: ブリーフと PR の説明に書く数と id は、コマンドやツールの結果から写す

## Status

Accepted

## Context

[ADR-0015](0015-copy-pm-address-from-listagents.md) はブリーフに書く PM の宛先を `ListAgents` から写すと決めた。
宛先のほかの数と id（session id、issue と PR の番号、AC の数、件数）を、どう書くかの決まりは無い。

このテンプレートの派生先 etoyama/knowledge-enhance の Epic 1（[#2](https://github.com/etoyama/knowledge-enhance/issues/2)、2026-11-23〜27）で、
PM が次の2つを手で書いて間違えた。振り返り（#2 の[コメント](https://github.com/etoyama/knowledge-enhance/issues/2#issuecomment-7215229679)）で確かめた。

- S1 のブリーフに、あり得ない session id を書いた。
- Epic PR（knowledge-enhance#10）の説明の下書きに、AC を34件と書いた。実際は33件だった。

どちらも書くターンでコマンドやツールを呼べば得られる値だった。

## Problem

- 課題1: ブリーフの id が違うと、子は違うセッションや issue を参照する。報告が届かない。
- 課題2: PR の説明の数が違うと、人間が違う数でレビューする。数を照らし直す手間を、人間が負う。
- 課題3: 数と id のたびにコマンドを呼ぶと、書く手間が増える。

扱わない範囲: PM の宛先（ADR-0015）。数と id のほかの本文。

## Decision Analysis

| # | 基準 | 区分 | 分類 | 重み（決めた人） | 出典 |
|---|---|---|---|---|---|
| M1 | 書いた数と id が、書いた時点の実物と合う | Must | - | - | 課題1、課題2 |
| W1 | 間違いが、子や人間に届く前に止まる | Want | 解決 | 高（人間。R5 を選んだ） | 課題1、課題2 |
| W2 | 書く手間 | Want | 費用 | 中（Claude の推測） | 課題3 |

| Must | A. 書くターンでコマンドやツールを呼び、その結果から写す | B. 手で書き、送る前にレビューで照らす | 何もしない |
|---|---|---|---|
| M1 | 満たす | 満たす（レビューが拾えば） | 満たさない（Epic 1 で2回外れた） |

| Want | A | B |
|---|---|---|
| W1 | 写す時点で合うので、届く前に止まる | レビューも数え間違えうる。拾えなければ届く |
| W2 | 値ごとにコマンドを1つ呼ぶ | レビューを1本回す |

- 差がつく基準: W1。
- 感度: どの重みを動かしても変わらない（W2 でも A の方が小さい）。

| 案 | 起きうる悪い結果 | 抑え方 |
|---|---|---|
| A | 写した後に実物が変わる（AC を足す、セッションを立て直す） | 送る直前のターンで写す |
| A | 写すコマンドの条件が違う（数える範囲がずれる） | PR の説明に、数えたコマンドを書いてよい |
| B | レビューが拾わず、間違いが届く | 抑えにくい |
| 何もしない | Epic 1 と同じ間違いが起きる | なし |

## Decision

A を採る。回し方の正本は pm-session のブリーフの型と §7 に置く。

- ブリーフと PR の説明に書く数と id は、書くターンでコマンドやツールを呼び、その結果から写す。記憶や、会話の前の方から写さない。
- 例: session id は `get_session`（`"self"`）や `list_sessions`、`start_session` の結果から写す。issue と PR の番号は `gh` の出力から、AC の数は DesignDoc を `grep -c` で数えて写す。

人間が R5 として選んだ（派生先の Epic 1 の振り返り、2026-11-27）。決め手は W1。

## Consequences

### Positive

- 子に違う id が届かない。人間が違う数でレビューしない。
- ADR-0015 の宛先と同じ形で、ほかの数と id も扱える。

### Negative

- 写すのを忘れることは、仕組みでは止めていない。
- 根拠は1件（Epic 1 の2つの間違い）だけである。

## Alternatives considered

- **ブリーフと PR の説明を、テンプレートから生成するスクリプトにする** — 書く場面が Epic ごとに違い、まだ同じ形が3回出ていない（YAGNI、Rule of Three）。

## Related

- [ADR-0015](0015-copy-pm-address-from-listagents.md)（PM の宛先は ListAgents から写す）
- 派生先の先行例: etoyama/knowledge-enhance の Epic 1（#2）の振り返り
