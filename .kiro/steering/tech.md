<!-- Steering Tech -->

# Tech

## Technology Stack

### Core Technologies

- **ファイル形式**: Markdown (.md)
- **スクリプト**: Bash (setup.sh)
- **設定形式**: JSON (エージェント設定、MCP設定)

このプロジェクトは主にドキュメント・テンプレート・ガイドライン集であり、コード実装はほぼ含まない。

---

## Platform Support

### 前提条件

- **Amazon Q Developer CLI**: エージェント実行環境
- **Git**: バージョン管理
- **jq**: JSON処理（setup.sh用）
- **Bash**: セットアップスクリプト実行環境

### 対応OS

macOS、Linux、Windows (WSL2) など、Amazon Q Developer CLIが動作する環境。

---

## Distribution & Setup

### 配布方法

ユーザはこのリポジトリをcloneまたはダウンロードして使用する。

### セットアップ方法

`setup.sh` を実行することで、Amazon Q Developer CLIのエージェント設定を自動生成する。

**現在のセットアップ機能**:
- MCP Server選択（mcp_servers.jsonから選択）
- 言語選択（日本語/英語）
- ユーザ名設定
- エージェント設定ファイル生成（`~/.aws/amazonq/cli-agents/`）

**将来の拡張**:
- 導入するコンテキストの選択機能
- プロジェクトタイプに応じたテンプレート選択

---

## Project Structure

```
q-spec-kit/
├── contexts/              # フレームワーク定義・ルール
│   ├── Q-SPEC Framework_en.md
│   ├── spec_rules_en.md
│   ├── git_rules.md
│   └── ...
├── steering_seeds/        # 設計思想・技術スタックのベストプラクティス
│   ├── design_philosophy/
│   └── tech_stacks/
├── templates/             # エージェント設定テンプレート
│   └── *.json.template
├── mcp_servers.json       # 利用可能なMCP定義
└── setup.sh               # セットアップスクリプト
```

---

## Customization Policy

### 初期セットアップ

setup.shによる対話的セットアップで、ユーザのプロジェクトに合わせた設定を生成。

### プロジェクトごとのカスタマイズ

各プロジェクトの `.kiro/steering/` ディレクトリに、必要なファイルをコピー・編集してカスタマイズする。

- vision.md: プロジェクトのビジョン
- tech.md: プロジェクト固有の技術的決定
- steering seeds: 必要に応じてコピー・調整

---

## Dependencies

### External Dependencies

- Amazon Q Developer CLI（必須）
- jq（setup.sh実行時のみ必要）

### MCP Servers（オプション）

setup.shで選択可能なMCP Servers:
- aws-documentation: AWS公式ドキュメント検索
- duckduckgo: Web検索
- その他（mcp_servers.jsonで定義）

MCPはオプションであり、プロジェクトのニーズに応じて選択する。

---

**Created**: 2025-01-05
