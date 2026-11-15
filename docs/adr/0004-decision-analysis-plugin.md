# ADR-0004: 判断の提示と ADR を Decision Analysis の形式にそろえる

## Status

Accepted

## Context

AI は ADR を書くときも、会話中に人間へ判断を仰ぐときも、選択肢と推奨だけを示していた。
ADR テンプレートの `## Context` には課題を書く欄がなく、`## Alternatives considered` は
却下理由を並べるだけで、比較の軸がなかった。人間は「なぜこの観点で比べたのか」
「なぜこれが Must なのか」を聞き返し、そのたびに往復が増えていた。

別のプロジェクトで AI に ADR を書き直させたとき、次の形が判断しやすく、議論もしやすかった。
課題に ID を振り、Must と Want を分け、Want を「解決」（課題をどれだけ解決できるか）と
「費用」（解決にどれだけ費用がかかるか）に分類して、重要なものだけに絞る形である。

比べるときに前提にした事実は次のとおり。

- repo-template はすでに外部プラグインの yomiyasu に依存し、`scripts/bootstrap.sh` で
  導入を案内している（ADR-0003 を読んで確かめた）。
- Must/Want を分ける Kepner-Tregoe 型の Claude Code スキルは既にある。ただし、確かめた3つ
  （thinking-kepner-tregoe、ddunnock/kepner-tregoe-analysis、lyndonkl/decision-matrix）は
  どれも、人間が判断の話を持ち出したときに発動する。AI が判断を仰ぐ直前に発動する仕組み、
  出し直しの手順、比較軸に出典を求める決まりは持たない。採点は数値で、ライセンスの記載も
  見当たらなかった（各 SKILL.md を読んで確かめた）。
- AskUserQuestion の直前に文脈を差し込む公式の hook はない（Claude Code の feature request を読んで確かめた）。

## Problem

- 課題1（事前）: AI が判断を仰ぐ最初の提示に、課題・比較軸・Must/Want の根拠がない。
  人間が聞き返すたびに往復が増える。
- 課題2（事後）: 提示が足りなかったとき、出し直させるたびに形式を一から説明し直す必要がある。

扱わない範囲: 判断の中身の正しさ。この ADR は提示の形式だけを扱う。

## Decision Analysis

| # | 基準 | 区分 | 分類 | 重み（決めた人） | 出典 |
|---|---|---|---|---|---|
| M1 | どの repo の会話でも効く | Must | - | - | 課題1, 人間の発言 |
| M2 | 一言で出し直しを指示できる | Must | - | - | 課題2, 人間の発言 |
| M3 | 形式の正本が1か所 | Must | - | - | WORKFLOW §2 |
| W1 | 最初の提示で Decision Analysis が出る | Want | 解決 | 高（人間） | 課題1 |
| W2 | repo-template の配布先でも同じ形式が使える | Want | 費用 | 高（人間） | 人間の発言 |
| W3 | 作る手間と保守する手間 | Want | 費用 | 中（AI の推測） | - |

| Must | 何もしない | A. グローバルの CLAUDE.md に全部書く | B. グローバルのスキル + CLAUDE.md に発動条件 | C. B をプラグインにする |
|---|---|---|---|---|
| M1 | 満たさない | 満たす | 満たす | 満たす |
| M2 | 満たさない | 満たす | 満たす | 満たす |
| M3 | - | 満たさない（配布先用に ADR テンプレートへ写しが要る） | 満たさない（同左） | 満たす |

| Want | C. プラグイン |
|---|---|
| W1 | SessionStart hook で発動条件が毎回入る。見極めを外したときは、人間の聞き返しを発動条件にして出し直させる |
| W2 | プラグインを導入すれば、配布先でも同じスキルを使える |
| W3 | スキルと見本と hook の3ファイル。repo を1つ増やす |

- 差がつく基準: M3。A と B は配布先で正本が2か所になる。
- 感度: W2 の重みが低い（自分の環境だけでいい）なら、B が写しなしで M3 を満たし、W3 で C に勝つ。

| 案 | 起きうる悪い結果 | 抑え方 |
|---|---|---|
| A | 全 repo の全セッションで、形式の全文がコンテキストを占める | 形式を短く保つ |
| B | 配布先では形式が存在しない | ADR テンプレートに写しを置く（M3 に反する） |
| C | 発動条件に当たる判断なのに、AI が当たらないと見て黙って進む | 人間の聞き返しを発動条件に入れる。漏れる場所を観測してから機械的な検査を足す |

## Decision

C を採る。決め手は M3。

- 形式の正本を [etoyama/decision-analysis](https://github.com/etoyama/decision-analysis)
  プラグインの `decision-analysis` スキルに置く。repo-template には形式を写さない。
- プラグインの SessionStart hook で発動条件を入れる。発動条件は次のとおり。
  選択肢が2つ以上あって既存の決定から一意に決まらない、戻しにくい、効果が今の作業を超える、
  人間が理由を聞き返した、人間が「DA で」と頼んだ。
- 出し直しは「DA で」または `/decision-analysis:decision-analysis` で指示する。
- ADR テンプレートに `## Problem` と `## Decision Analysis` を足す。
  `## Alternatives considered` には、評価の前に落とした案だけを置く。
- DesignDoc の `### Decision:` には `Criteria`（比べた基準と出典）の1行を足す。
  Epic 内の決定は小さいので、Decision Analysis の全体は求めない。
- プラグインを配布先に入れる方法は、下の「配布先への導入」で決める。yomiyasu にも同じ方法を使い、
  ADR-0003 の「bootstrap.sh で導入を案内する」を置き換える。
- 既存の ADR-0001〜0003 は書き直さない。新しい ADR から適用する。

### 配布先への導入

- 課題3: プラグインは clone ごとに入れる必要がある。一方 `scripts/bootstrap.sh` は GitHub の
  labels を作るスクリプトで、repo ごとに作成者が1回だけ実行する。導入を bootstrap の案内に
  頼ると、チームメイトの clone には入らず、入っていないことにも気づけない。
- 前提にした事実は次のとおり。Claude Code の公式ドキュメント settings / discover-plugins / plugins/loading を読み、
  使い捨ての repo で CLI を実行して確かめた。
  - `.claude/settings.json` に `extraKnownMarketplaces` と `enabledPlugins` をコミットしても、
    プラグインは入らない。入っていない間は、`/plugin` の Errors に「有効なのに入っていない」と出る。
  - `claude plugin marketplace add <repo> --scope project` と
    `claude plugin install <plugin>@<marketplace> --scope project` は2回実行しても exit 0 で、
    `.claude/settings.json` に差分を出さない（キーの順を CLI の出力に合わせた場合）。
  - クラウドのセッションは repo の settings に書いたプラグインを読み込まない。

| # | 基準 | 区分 | 分類 | 重み（決めた人） | 出典 |
|---|---|---|---|---|---|
| M1 | 導入を人の記憶だけに頼らない | Must | - | - | 課題3 |
| M2 | 派生 repo にプラグインの実体を複製しない | Must | - | - | WORKFLOW §2 |
| W1 | 入っていないときに気づける | Want | 解決 | 高（人間。派生 repo はチームで共有する） | 課題3 |
| W2 | 導入1回あたりの手数 | Want | 費用 | 中（AI の推測） | - |

| Must | 何もしない（bootstrap で案内を表示する） | P. settings.json をコミットする | Q. bootstrap が導入まで実行する | P+Q |
|---|---|---|---|---|
| M1 | 満たさない | 満たさない（気づくには `/plugin` を開く必要があり、導入もしない） | 満たす | 満たす |
| M2 | 満たす | 満たす | 満たす | 満たす |

| Want | Q | P+Q |
|---|---|---|
| W1 | bootstrap を実行した作成者の clone にしか入らない。チームメイトの clone は気づけない | 宣言がコミットされているので、チームメイトの環境でも `/plugin` の Errors に出る |
| W2 | 作成者は bootstrap を実行するだけ | 作成者は同じ。チームメイトは `scripts/install-plugins.sh` を1回実行する |

- 差がつく基準: W1。
- 感度: 派生 repo を一人で使うなら W1 の差が消え、ファイルが1つ少ない Q が W2 で勝つ。

P+Q を採る。

- `.claude/settings.json` で yomiyasu と decision-analysis を宣言し、有効にする。
- 導入は `scripts/install-plugins.sh`（clone ごと、冪等）が行う。`scripts/bootstrap.sh` は labels を作ったあとにこれを呼ぶ。
- `claude` CLI がない、または導入に失敗したときは警告だけを出し、labels の作成は止めない。

## Consequences

### Positive

- 人間は比較軸の出典と重みを決めた人を見て、基準の立て方そのものに質問できる。
- 提示が足りなかったとき、形式を説明し直さずに一言で出し直させられる。
- 配布先でも同じ形式を使える。

### Negative

- 外部プラグインへの依存が1つ増える。`scripts/install-plugins.sh` を実行していない clone では、
  発動条件が入らない（`/plugin` の Errors には出る）。
- クラウドのセッションでは、プラグインが読み込まれず、発動条件が入らない。
- 入れたくない人にも有効化を求める。外すときは `.claude/settings.local.json` で `false` にする。
- 発動条件の見極めは AI の判断に任せる。黙って進むことを機械的には止められない。
- AskUserQuestion の hook による検査は入れていない。漏れが続いたら別の ADR で足す。

## Alternatives considered

- **既にある Kepner-Tregoe 型のスキルを使う** — AI が判断を仰ぐ直前に発動せず（M1）、出し直しの手順もない（M2）。ライセンスが不明なので写して持てない。
- **既にあるスキルを、自作の小さなスキルから呼ぶ** — 数値採点と、出典を求めない基準の立て方を、自作のスキルの側で打ち消し続けることになる。
- **AskUserQuestion の PreToolUse hook で検査する** — 判断を仰ぐのが本文だけの場合はすり抜ける。小さな確認にも誤検知が出る。
- **insight-blueprint-skills の marketplace に同居させる** — EDA 用の単一プラグインの marketplace で、目的が合わない。
- **repo-template 自体を marketplace にする** — テンプレートから派生した repo すべてに、プラグインの実体が複製される（M3）。

## Related

- [etoyama/decision-analysis](https://github.com/etoyama/decision-analysis)
- 関連: [ADR-0003](0003-yomiyasu-for-japanese-docs.md)（外部プラグインを bootstrap で案内する前例）
