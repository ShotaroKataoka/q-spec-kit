<!-- SPEC Tasks Template -->

# Tasks: Steering構成の刷新

**Related SPECs**: steering-redesign

## Implementation Checklist

### Phase 1: 新しいsteeringテンプレート作成

- [x] `contexts/steering_templates/vision.md` 作成
  - [x] Problem Statement セクション
  - [x] Target Users セクション
  - [x] Existing Solutions & Gaps セクション
  - [x] Project Goal セクション
  - [x] Success Criteria セクション
  - [x] 記載例を含める

- [x] `contexts/steering_templates/principles.md` 作成
  - [x] Core Values セクション
  - [x] Decision Framework セクション
  - [x] Trade-off Priorities セクション
  - [x] Consistency Rules セクション
  - [x] 記載例を含める

- [x] `contexts/steering_templates/constraints.md` 作成
  - [x] Technical Boundaries セクション
  - [x] Prohibited Practices セクション
  - [x] Dependency Policy セクション
  - [x] Compatibility Requirements セクション
  - [x] 記載例を含める

- [x] ~~`contexts/steering_templates/architecture.md` 作成~~ → 削除（設計思想seedsと重複）

### Phase 2: 既存テンプレートの削除

- [x] `contexts/steering_templates/product.md` 削除
- [x] `contexts/steering_templates/tech.md` 削除
- [x] `contexts/steering_templates/structure.md` 削除
- [x] `contexts/steering_templates/architecture.md` 削除

### Phase 3: project_startup.mdの更新

- [x] 新しいsteering構成の説明を追加（3ファイル + seeds）
- [x] 4フェーズの初期化プロセスを記載
  - [x] フェーズ1: プロジェクト理解（vision.md）
  - [x] フェーズ2: 価値観の明確化（principles.md）
  - [x] フェーズ3: 設計思想の選択（seeds選択・コピー）
  - [x] フェーズ4: 技術制約の定義（constraints.md + seeds選択・コピー）

- [x] 各フェーズのヒアリング質問例を充実
  - [x] 推論ベースインタビュー形式
  - [x] 「なぜ」を引き出す質問
  - [x] トレードオフの優先順位を明確にする質問

- [x] seeds選択・適用の順序を明記
  - [x] 設計思想seeds → `.kiro/steering/` にコピー
  - [x] 技術スタックseeds → `.kiro/steering/` にコピー

- [x] 完了基準を明確化
  - [x] 「普遍的な真実」の判断基準
  - [x] 内容の具体性チェック
  - [x] ユーザー確認プロセス

- [x] 既存の product/tech/structure への言及を削除

### Phase 4: 動作確認

- [x] テンプレートファイルが正しく配置されているか確認
- [x] project_startup.mdの内容が一貫しているか確認
- [x] 記載例が「普遍的な真実」の基準を満たしているか確認

### Phase 5: ドキュメント更新

- [x] steering_seeds_guide.mdの更新（必要に応じて）
  - [x] 新しいsteering構成との関係を明記
  - [x] seedsとsteeringの役割分担を明確化
  
**確認結果**: steering_seeds_guide_en.mdは既に新しい構成と整合性が取れているため、修正不要。

---
**Created**: 2025-11-04
