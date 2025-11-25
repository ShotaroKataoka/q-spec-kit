# Requirements: Kiro CLIリブランド対応アップデート
**Related SPECs**: kiro-cli-rebrand-update

## Background & Context

### User Problems

Amazon Q Developer CLIがKiro CLIにリブランドされ、以下の変更が発生した：
- コマンド名: `amazonq` → `kiro-cli`
- 設定ディレクトリ: `~/.aws/amazonq/` → `~/.kiro/`
- エージェント設定ディレクトリ: `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`

現在のq-spec-kitはこれらの変更に対応しておらず、setup.shやドキュメントが古いパスを参照している。

### Related Issues

実環境確認結果：
- kiro-cli 1.20.0がインストール済み
- 新パス `~/.kiro/agents/` が存在し、使用可能
- 旧パス `~/.aws/amazonq/cli-agents/` も残存（移行期間中）

## Objectives

q-spec-kitを新しいKiro CLIに対応させ、ユーザが正しくセットアップできるようにする。

## Scope

### In Scope

- setup.shのエージェント設定パス変更
- README.mdの記述更新
- MCP_SERVERS.mdの記述更新
- contextsディレクトリ内のドキュメント更新（必要に応じて）

### Out of Scope

- 旧パスへの後方互換性サポート（新パスのみ対応）
- 既存ユーザの設定マイグレーション機能（手動対応を想定）

## Detailed Requirements

### 変更対象ファイル

grep結果から以下のファイルが対象：
1. `setup.sh`: `AGENTS_DIR="$HOME/.aws/amazonq/cli-agents"` → `AGENTS_DIR="$HOME/.kiro/agents"`
2. `README.md`: `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`
3. `MCP_SERVERS.md`: `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`

### 変更方針

- パス変更: `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`
- コマンド名変更: 必要に応じて `amazonq` → `kiro-cli`
- 製品名変更: 文脈に応じて "Amazon Q Developer CLI" → "Kiro CLI"

contextsディレクトリ内のファイルは、grep結果に出現しなかったため、現時点では変更不要と判断。
ただし、念のため主要ファイルを確認する。

---
**Created**: 2025-11-22
