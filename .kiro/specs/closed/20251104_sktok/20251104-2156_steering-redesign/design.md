<!-- SPEC Design Template -->

# Design: Steering構成の刷新

**Related SPECs**: steering-redesign

## Architecture Overview

### 新しいsteering構成

```
.kiro/steering/
├── vision.md          # プロジェクトの存在理由（WHY）
├── principles.md      # 判断原則・価値観（HOW TO DECIDE）
├── constraints.md     # 技術的境界線（WHAT NOT TO DO）
├── clean_architecture.md  # 設計思想seed（HOW TO STRUCTURE）
└── python.md              # 技術スタックseed（LANGUAGE STANDARDS）
```

**設計判断**: 
- architecture.mdは設計思想seedsと内容が重複するため削除
- seedsは `.kiro/steering/` 直下にフラットに配置（階層は認識されない）
- 設計思想seedsが構造の原則を提供

### 設計原則

1. **普遍性**: プロジェクトの進化に関わらず変わらない原則のみを記載
2. **判断基準**: エージェントが迷ったときに参照できる具体的な基準
3. **分離**: 不変情報（steering）と可変情報（コード・SPEC）を明確に分離

## Component Design

### 1. vision.md

**目的**: プロジェクトの「なぜ」を明確にする

**構成**:
```markdown
# Vision

## Problem Statement
このプロジェクトが解決する問題

## Target Users
誰のためのプロジェクトか

## Existing Solutions & Gaps
既存ソリューションの何が不足しているか

## Project Goal
このプロジェクトが実現すること

## Success Criteria
プロジェクトが成功したと言える状態
```

**記載例**:
```markdown
## Problem Statement
開発者がCLIツールを作る際、引数パース・設定管理・ログ出力などの
ボイラープレートコードを毎回書く必要があり、本質的なロジックに集中できない。

## Target Users
- CLIツールを頻繁に作成するPython開発者
- シンプルで保守しやすいコードを重視する開発者

## Existing Solutions & Gaps
- Click/Typer: 機能は豊富だが、学習コストが高く、シンプルなツールには過剰
- argparse: 標準ライブラリだが、冗長で読みにくいコードになりがち
- このプロジェクトは「最小限の記述で最大限の機能」を実現する

## Project Goal
10行以下のコードで、プロダクションレディなCLIツールを作成できるようにする

## Success Criteria
- 初心者が5分でCLIツールを作成できる
- 作成されたツールが標準的なCLI規約に準拠している
```

### 2. principles.md

**目的**: 判断の優先順位とトレードオフの基準を明確にする

**構成**:
```markdown
# Principles

## Core Values
プロジェクトが最も重視する価値観（優先順位付き）

## Decision Framework
迷ったときの判断基準

## Trade-off Priorities
トレードオフが発生したときの優先順位

## Consistency Rules
設計の一貫性を保つためのルール
```

**記載例**:
```markdown
## Core Values
1. **Simplicity**: 複雑さを避け、理解しやすいコードを優先
2. **User Experience**: 開発者が使いやすいAPIを提供
3. **Reliability**: 動作の予測可能性と安定性
4. **Performance**: 必要十分な速度（過度な最適化はしない）

## Decision Framework
新しい機能を追加するとき:
1. 80%のユースケースをカバーするか？
2. APIがシンプルに保たれるか？
3. 既存機能との一貫性があるか？

全てYesなら追加、1つでもNoなら見送る。

## Trade-off Priorities
- Simplicity vs Features → Simplicity優先（機能は最小限に）
- Performance vs Readability → Readability優先（ボトルネックのみ最適化）
- Flexibility vs Convention → Convention優先（設定より規約）

## Consistency Rules
- エラーは必ず例外で伝播（戻り値でのエラー表現は禁止）
- 公開APIは全て型ヒント必須
- 設定は環境変数で注入（グローバル変数禁止）
```

### 3. constraints.md

**目的**: 技術的な境界線と禁止事項を明確にする

**構成**:
```markdown
# Constraints

## Technical Boundaries
サポート範囲の境界線

## Prohibited Practices
やってはいけないこと

## Dependency Policy
外部依存の方針

## Compatibility Requirements
互換性の要件
```

**記載例**:
```markdown
## Technical Boundaries
- **Python Version**: 3.10以上（型ヒント機能が必要）
- **Platform**: Linux/macOS/Windows（クロスプラットフォーム必須）
- **Use Case**: CLIツール専用（GUIは対象外）

## Prohibited Practices
- グローバル状態の使用（テスタビリティを損なう）
- 同期処理のブロッキング（asyncは使わない、複雑性を避ける）
- 暗黙的な型変換（明示的な変換のみ）

## Dependency Policy
- 標準ライブラリを最優先
- 外部依存は最小限（追加時は必ず理由を明記）
- 依存ライブラリは広く使われているもののみ（メンテナンス性）

## Compatibility Requirements
- 後方互換性を保つ（破壊的変更は major version up のみ）
- 非推奨化は1バージョン前に警告を出す
```

## 初期化プロセスの設計

### フェーズ1: プロジェクト理解

**目的**: プロジェクトの本質を理解する

**ヒアリング項目**:
1. **問題の深掘り**
   - 「どのような問題を解決したいですか？」
   - 「現在はどのように対処していますか？」
   - 「既存の方法の何が不満ですか？」

2. **ユーザー理解**
   - 「誰がこのプロジェクトを使いますか？」
   - 「ユーザーの技術レベルは？」
   - 「ユーザーが最も重視することは？」

3. **ゴール明確化**
   - 「このプロジェクトが成功したと言える状態は？」
   - 「最も重要な機能は何ですか？」
   - 「逆に、やらないことは何ですか？」

**成果物**: vision.md の下書き

### フェーズ2: 価値観の明確化

**目的**: 判断基準とトレードオフの優先順位を決める

**ヒアリング項目**:
1. **価値観の優先順位**
   - 「シンプルさと機能の豊富さ、どちらを優先しますか？」
   - 「パフォーマンスと可読性、どちらを優先しますか？」
   - 「柔軟性と規約、どちらを優先しますか？」

2. **一貫性のルール**
   - 「エラー処理はどのように統一しますか？」
   - 「設定の注入方法は？」
   - 「ログ出力の方針は？」

**成果物**: principles.md の下書き

### フェーズ3: 設計思想の選択

**目的**: プロジェクトに適した設計思想を選ぶ

**ヒアリング項目**:
1. **設計思想の確認**
   - 「Clean Architecture、DDD、Hexagonal、Simplicity-First のうち、どれに共感しますか？」
   - 「レイヤー分割は必要ですか？」
   - 「ドメインモデルは複雑ですか？」

2. **seeds選択**
   - 該当する設計思想seedを読み込む
   - 内容を説明し、適用可否を確認
   - `.kiro/steering/` にコピー

**成果物**: 設計思想seedsの選択・コピー

### フェーズ4: 技術制約の定義

**目的**: 技術的な境界線を明確にする

**ヒアリング項目**:
1. **技術スタック**
   - 「言語・バージョンは？」
   - 「フレームワークは？」
   - 「プラットフォームは？」

2. **技術スタックseeds選択**
   - 該当する技術スタックseedを読み込む
   - 内容を説明し、適用可否を確認

3. **制約の確認**
   - 「サポート範囲は？」
   - 「禁止事項は？」
   - 「外部依存の方針は？」

**成果物**: constraints.md の作成、技術スタックseedsのコピー

### フェーズ4: 最終確認

**目的**: 全体の整合性を確認し、ユーザーの合意を得る

**確認項目**:
1. 各steeringファイルに「普遍的な真実」が記載されているか
2. エージェントが判断基準として活用できる具体性があるか
3. ユーザーとの認識齟齬がないか

**成果物**: 完成したsteering一式

## Implementation Notes

### テンプレートファイルの配置

```
contexts/steering_templates/
├── vision.md
├── principles.md
└── constraints.md
```

### project_startup.mdの更新内容

1. 新しいsteering構成の説明（3ファイル + seeds）
2. 4フェーズの初期化プロセス
3. 各フェーズのヒアリング質問例
4. seeds選択・適用の順序
5. 完了基準の明確化

### 既存ファイルの扱い

- `product.md`, `tech.md`, `structure.md` は削除
- 新しいテンプレートに置き換え

---
**Created**: 2025-11-04
