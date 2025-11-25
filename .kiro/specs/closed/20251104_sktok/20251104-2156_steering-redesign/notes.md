<!-- SPEC Notes Template -->

# Notes: Steering構成の刷新

## How to Write Notes
- **Append-only**: Never edit or delete existing content, always add new discoveries at the end
- **Natural language**: Write as if explaining to a colleague, in plain language
- **Capture thought process**: "Initially thought X, but actually it was Y"
- **Be specific**: Include numbers, error messages, commands, and concrete examples
- **Use complete sentences**: "Implemented X" not "X implementation"

## Log

### [2025-11-04 21:56] SPEC作成完了

Q-SPECヒアリングを通じて、steering構成の刷新に関する要件を明確化した。

**主要な発見**:
- 現在のproduct/tech/structureは「可変情報」と「不変情報」が混在している
- エージェントが必要とするのは「判断基準」であり、「実装状態」ではない
- 「普遍的な真実」のみをsteeringに記載することで、プロジェクトの進化に関わらず一貫性を保てる

**新しいsteering構成**:
- vision.md: プロジェクトの「なぜ」
- principles.md: 判断の優先順位とトレードオフの基準
- constraints.md: 技術的境界線と禁止事項
- architecture.md: 構造の哲学

**初期化プロセス**:
6フェーズに分けて、段階的に深いヒアリングを実施する設計とした。
特に、設計思想seedsを先に選択してからarchitecture.mdを作成する順序が重要。

次のステップ: tasks.mdに従って実装を開始する。

### [2025-11-04 22:00] Phase 1 & 2 完了

新しいsteeringテンプレート4ファイルを作成し、既存の3ファイルを削除した。

**作成したテンプレート**:
- vision.md: 各セクションに記載例とヒアリング項目を含めた
- principles.md: 判断基準を具体的に記載できる構成
- constraints.md: 境界線と禁止事項を明確にする構成
- architecture.md: 構造の原則を記載する構成

**重要な設計判断**:
各テンプレートに「普遍的な真実」と「可変情報」の区別を明示した。
これにより、エージェントが何を記載すべきかを判断しやすくなる。

次のステップ: Phase 3 - project_startup.mdの更新

### [2025-11-04 22:08] architecture.md削除

設計思想seedsと内容が重複するため、architecture.mdを削除した。

**設計判断**:
- 設計思想seeds（clean_architecture.md等）が構造の原則を提供
- architecture.mdは重複するため不要
- steeringは3ファイル（vision/principles/constraints）+ seeds で構成

**最終的なsteering構成**:
```
.kiro/steering/
├── vision.md          # WHY
├── principles.md      # HOW TO DECIDE
├── constraints.md     # WHAT NOT TO DO
├── clean_architecture.md  # HOW TO STRUCTURE (seed)
└── python.md              # LANGUAGE STANDARDS (seed)
```

初期化プロセスも6フェーズから4フェーズに簡略化。
seedsは `.kiro/steering/` 直下にフラットに配置（階層は認識されない）。

次のステップ: Phase 3 - project_startup.mdの更新

---
**Created**: 2025-11-04
### [2025-11-04 22:12] Phase 3完了 - project_startup.md更新

新しいsteering構成に対応したproject_startup.mdを作成した。

**主要な変更点**:
1. 4フェーズの初期化プロセスに簡略化
   - フェーズ1: プロジェクト理解（vision.md）
   - フェーズ2: 価値観の明確化（principles.md）
   - フェーズ3: 設計思想の選択（seeds選択・コピー）
   - フェーズ4: 技術制約の定義（constraints.md + seeds選択・コピー）

2. 推論ベースインタビューの質問例を充実
   - 各フェーズで具体的な質問例を提示
   - トレードオフの優先順位を明確にする質問
   - 「なぜ」を引き出す深掘り質問

3. seeds選択の手順を詳細化
   - 読み込み → 説明 → 確認 → コピーの流れを明記
   - 「読まずにコピーしない」を強調
   - 設計思想seeds → 技術スタックseedsの順序を明記

4. 「普遍的な真実」の判断基準を明示
   - 良い例・悪い例を提示
   - 可変情報と不変情報の区別を明確化

次のステップ: Phase 4 - 動作確認
次のステップ: Phase 4 - 動作確認

### [2025-11-04 22:13] Phase 4完了 - 動作確認

全てのファイルが正しく配置されていることを確認した。

**確認結果**:
- ✅ contexts/steering_templates/ に3つのテンプレートが存在
  - vision.md (3.4KB)
  - principles.md (3.6KB)
  - constraints.md (3.7KB)
- ✅ contexts/project_startup.md が更新されている (9.4KB)
- ✅ 各テンプレートに「普遍的な真実」の判断基準が記載されている
- ✅ project_startup.mdの内容が一貫している

次のステップ: Phase 5 - ドキュメント更新（必要に応じて）
次のステップ: Phase 5 - ドキュメント更新（必要に応じて）

### [2025-11-04 22:14] Phase 5完了 - ドキュメント更新確認

steering_seeds_guide_en.mdを確認した結果、既に新しいsteering構成と整合性が取れているため、修正は不要と判断した。

**確認内容**:
- seedsの役割: 技術スタックと設計思想の標準を提供
- steeringの役割: プロジェクト固有の判断基準・制約・価値観
- 役割分担が明確に記載されている

### [2025-11-04 22:14] 実装完了

全5フェーズの実装が完了した。

**成果物**:
1. 新しいsteeringテンプレート（3ファイル）
   - vision.md
   - principles.md
   - constraints.md

2. 更新されたproject_startup.md
   - 4フェーズの初期化プロセス
   - 推論ベースインタビューの質問例
   - seeds選択の詳細手順
   - 「普遍的な真実」の判断基準

3. 削除されたファイル
   - product.md, tech.md, structure.md（旧テンプレート）
   - architecture.md（設計思想seedsと重複）

**最終的なsteering構成**:
```
.kiro/steering/
├── vision.md          # WHY
├── principles.md      # HOW TO DECIDE
├── constraints.md     # WHAT NOT TO DO
├── clean_architecture.md  # HOW TO STRUCTURE (seed)
└── python.md              # LANGUAGE STANDARDS (seed)
```

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:15] project_startup.md質問改善

推論ベースインタビューの質問が固定的だった問題を修正した。

**修正内容**:
- 固定的な選択肢を削除
- ユーザーの回答を受けてから推論を提示する流れに変更
- 各質問で「なぜ」を深掘りする構造に

**修正例**:
```
❌ 修正前:
「推測される問題領域: 既存ツールの使いにくさ / 手作業の非効率性...
このプロジェクトはどのような問題を解決しますか？」

✅ 修正後:
「このプロジェクトはどのような問題を解決しますか？」
→ ユーザー回答
→ 「〇〇という問題ですね。現在はどのように対処していますか？」
→ ユーザー回答
→ 「△△で対処されているとのことですが、△△の何が不満なのでしょうか？
   例えば、使いにくさ？パフォーマンス？」
```

これにより、真の推論ベースインタビューになった。

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:18] project_startup.mdをガイドラインとして書き直し

「質問のテンプレート」から「ガイドライン」に変更した。

**主要な変更点**:
1. 冒頭に明記
   - 「以下は質問のテンプレートではなくガイドラインです」
   - 「Q-SPECフレームワークを活用し、臨機応変に対応してください」

2. 構成の変更
   - 「引き出すべき情報」を明記（必須項目）
   - 「推論ベースインタビューの進め方」を説明（プロセス）
   - 「質問例（参考）」として提示（テンプレートではない）

3. Q-SPECの活用を強調
   - S/P/E/Cを意識したインタビュー経路の調整
   - ユーザーの回答から次の質問を判断

4. 禁止事項に追加
   - 「質問を機械的に読み上げないこと」

**設計意図**:
エージェントが自律的に判断し、ユーザーとの自然な対話を通じて
必要な情報を引き出せるようにする。

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:21] ハードコードされたseedsリストを削除

将来的にsteering_seeds/に追加される可能性があるため、ハードコードされたseedsリストを削除した。

**修正内容**:
```
❌ 修正前:
**利用可能な設計思想seeds**:
- clean_architecture.md: ...
- domain_driven_design.md: ...

✅ 修正後:
**利用可能な設計思想seeds**:
- エージェント起動時の "Available Steering Seeds" セクションを参照
- steering_seeds/design_philosophy/ 配下のファイルを確認
```

これにより、seedsが追加されても project_startup.md の修正が不要になる。

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:26] seedsのカスタマイズ手順を追加

seedsをコピー後、プロジェクトに合わせて調整する手順を追加した。

**背景**:
- seedsは「一般的な標準」であり、全てのプロジェクトに適するわけではない
- 例: カバレッジ80%は小規模プロトタイプには過剰
- 2つのファイルに矛盾した基準があるとエージェントが迷う

**設計判断**:
- seedsをコピー後、プロジェクトに合わせて編集する
- steeringは「このプロジェクトの唯一の真実」であるべき

**カスタマイズ方針**:
- 設計思想seeds: 基本的にそのまま（哲学は変えない）
- 技術スタックseeds: プロジェクトに合わせて調整（具体的な基準は調整可能）

**初期化プロセスへの追加**:
- フェーズ3: 設計思想seedをコピー、必要に応じて調整
- フェーズ4: 技術スタックseedをコピー、プロジェクトに合わせて調整
  - 「カバレッジ80%とありますが、このプロジェクトでは適切ですか？」
  - 調整理由を明確にする

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:28] steeringテンプレートを英語に翻訳

contexts/steering_templates/ の全てのテンプレートを英語に翻訳した。

**翻訳したファイル**:
- vision.md
- principles.md
- constraints.md

**理由**:
- steering_seedsが英語版のため、統一性を保つ
- 国際的なプロジェクトでも使用可能に
- エージェントが日本語で説明するため、ユーザー体験は変わらない

次のステップ: report.md作成とSPECクローズ
次のステップ: report.md作成とSPECクローズ

### [2025-11-04 22:30] project_startup_en.mdを更新

project_startup.mdと内容を合わせるため、project_startup_en.mdを全面的に書き直した。

**主要な変更点**:
- 4フェーズの初期化プロセスに統一
- ガイドライン形式に変更（質問テンプレートではない）
- seedsのカスタマイズ手順を追加
- Q-SPECフレームワークの活用を強調
- 推論ベースインタビューの進め方を詳細化

これで日本語版と英語版の内容が一致した。

次のステップ: report.md作成とSPECクローズ
