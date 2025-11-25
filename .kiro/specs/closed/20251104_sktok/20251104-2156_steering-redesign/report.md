<!-- SPEC Report Template -->

# Report: Steering構成の刷新

**Related SPECs**: steering-redesign  
**Status**: Completed  
**Completed**: 2025-11-04

## Summary

プロジェクト初期化時に作成するsteering構成を刷新した。
従来のproduct/tech/structureから、vision/principles/constraintsに変更し、
「普遍的な真実」のみを記載する設計に改善した。

## Achievements

### 1. 新しいsteering構成の設計・実装

**作成したテンプレート**:
- `contexts/steering_templates/vision.md`: プロジェクトの存在理由
- `contexts/steering_templates/principles.md`: 判断原則・価値観
- `contexts/steering_templates/constraints.md`: 技術的境界線

**削除したテンプレート**:
- `product.md`, `tech.md`, `structure.md`: 可変情報と不変情報が混在
- `architecture.md`: 設計思想seedsと重複

**最終的なsteering構成**:
```
.kiro/steering/
├── vision.md          # WHY
├── principles.md      # HOW TO DECIDE
├── constraints.md     # WHAT NOT TO DO
├── [design_philosophy_seed].md  # HOW TO STRUCTURE
└── [tech_stack_seed].md         # LANGUAGE STANDARDS
```

### 2. 初期化プロセスの再設計

**4フェーズの初期化プロセス**:
1. プロジェクト理解（vision.md作成）
2. 価値観の明確化（principles.md作成）
3. 設計思想の選択（seeds選択・コピー・調整）
4. 技術制約の定義（constraints.md作成 + seeds選択・コピー・調整）

**主要な改善点**:
- 質問テンプレート → ガイドライン形式に変更
- Q-SPECフレームワークの活用を強調
- 推論ベースインタビューの進め方を詳細化
- seedsのカスタマイズ手順を追加

### 3. ドキュメント更新

**更新したファイル**:
- `contexts/project_startup.md`: 日本語版、4フェーズのガイドライン
- `contexts/project_startup_en.md`: 英語版、日本語版と内容を統一

**テンプレートの英語化**:
- 全てのsteeringテンプレートを英語に統一
- steering_seedsとの一貫性を保つ

## Key Decisions

### 1. 「普遍的な真実」の原則

**決定**: steeringには可変情報を含めず、プロジェクトの進化に関わらず変わらない原則のみを記載

**理由**:
- 可変情報（実装状態、現在の機能）は時間とともに変化
- steeringは「このプロジェクトの唯一の真実」として機能すべき
- エージェントが判断基準として活用できる

### 2. architecture.mdの削除

**決定**: architecture.mdを削除し、設計思想seedsで代替

**理由**:
- 設計思想seeds（clean_architecture.md等）と内容が重複
- 重複を避け、steeringをシンプルに保つ
- seedsが構造の原則を提供

### 3. seedsのカスタマイズ

**決定**: seedsをコピー後、プロジェクトに合わせて調整可能

**理由**:
- seedsは「一般的な標準」であり、全てのプロジェクトに適するわけではない
- 2つのファイルに矛盾した基準があるとエージェントが迷う
- 初期化時にカスタマイズすることで「このプロジェクトの真実」にする

**カスタマイズ方針**:
- 設計思想seeds: 基本的にそのまま（哲学は変えない）
- 技術スタックseeds: プロジェクトに合わせて調整（具体的な基準は調整可能）

### 4. ガイドライン形式への変更

**決定**: 質問テンプレートではなく、ガイドラインとして提供

**理由**:
- 質問を機械的に読み上げるのではなく、臨機応変に対応すべき
- Q-SPECフレームワークを活用し、ユーザーの回答に応じてインタビュー経路を調整
- 「引き出すべき情報」と「質問例」を分離

## Lessons Learned

### 1. 推論ベースインタビューの設計

**課題**: 当初の質問例は固定的な選択肢を提示していた

**改善**: ユーザーの回答を受けてから推論を提示する流れに変更

**学び**: 真の推論ベースインタビューは、ユーザーの回答から推測を組み立てるプロセス

### 2. seedsの役割

**課題**: seedsをそのまま使うか、カスタマイズするか

**改善**: 初期化時にカスタマイズする方針に決定

**学び**: 「一般的な標準」と「プロジェクト固有の真実」を区別することが重要

### 3. ハードコードの回避

**課題**: 利用可能なseedsリストをハードコードしていた

**改善**: "Available Steering Seeds" セクションへの参照に変更

**学び**: 将来の拡張性を考慮し、動的に参照する設計にすべき

## Impact

### Positive

1. **高品質なsteeringの作成**: 「普遍的な真実」を記載することで、エージェントの判断基準として機能
2. **一貫性の向上**: 可変情報と不変情報を分離し、矛盾を回避
3. **柔軟性の向上**: ガイドライン形式により、臨機応変なインタビューが可能
4. **拡張性の向上**: seedsの追加に対応しやすい設計

### Potential Issues

1. **初期化の複雑化**: 4フェーズのプロセスは従来より複雑
2. **エージェントの負担**: ガイドライン形式は、エージェントの判断力に依存
3. **テンプレート未検証**: 実際のプロジェクトでの動作確認が必要

## Next Steps

1. **実際のプロジェクトでの検証**: 新しいsteering構成で初期化を実施
2. **テンプレートの改善**: 実際の使用を通じて、テンプレートを改善
3. **steeringの更新プロセス**: 初期化後のsteering更新ルールの策定（別SPEC）
4. **エージェントテンプレートの更新**: templates/Q-SPEC-dev-agent.json.template の見直し

## Files Changed

### Created
- `.kiro/specs/20251104-2156_steering-redesign/requirements.md`
- `.kiro/specs/20251104-2156_steering-redesign/design.md`
- `.kiro/specs/20251104-2156_steering-redesign/tasks.md`
- `.kiro/specs/20251104-2156_steering-redesign/notes.md`
- `contexts/steering_templates/vision.md`
- `contexts/steering_templates/principles.md`
- `contexts/steering_templates/constraints.md`

### Modified
- `contexts/project_startup.md`
- `contexts/project_startup_en.md`

### Deleted
- `contexts/steering_templates/product.md`
- `contexts/steering_templates/tech.md`
- `contexts/steering_templates/structure.md`
- `contexts/steering_templates/architecture.md`

---
**Completed**: 2025-11-04
