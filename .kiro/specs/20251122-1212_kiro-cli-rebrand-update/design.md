# Design: Kiro CLIリブランド対応アップデート

## Overview

q-spec-kit内の全ファイルで、Amazon Q Developer CLI関連のパスとコマンド名をKiro CLIの新しい仕様に更新する。

## Design Decisions

### 変更対象の特定

grep検索により以下のファイルが対象と判明：
- `setup.sh`
- `README.md`
- `MCP_SERVERS.md`

contextsディレクトリ内のファイルには該当記述が見つからなかったが、念のため以下を確認：
- `contexts/spec_rules_en.md`
- `contexts/user_preference_dev-agent2.md`
- `contexts/steering_seeds_guide_en.md`

### 変更内容

#### 1. setup.sh

**変更箇所**:
```bash
# Before
AGENTS_DIR="$HOME/.aws/amazonq/cli-agents"

# After
AGENTS_DIR="$HOME/.kiro/agents"
```

**理由**: エージェント設定ファイルの出力先を新パスに変更

#### 2. README.md

**変更箇所**:
- `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`

**理由**: ドキュメント内のパス参照を新パスに更新

#### 3. MCP_SERVERS.md

**変更箇所**:
- `~/.aws/amazonq/cli-agents/` → `~/.kiro/agents/`

**理由**: MCP設定手順内のパス参照を新パスに更新

### 製品名の扱い

- "Amazon Q Developer CLI" → "Kiro CLI" への変更は、文脈を確認しながら実施
- 技術的な説明では "Kiro CLI" を使用
- 歴史的経緯の説明では両方を併記する可能性あり

## Implementation Notes

- 単純な文字列置換で対応可能
- 破壊的変更のため、ユーザへの周知が必要
- 既存ユーザは手動で設定を `~/.kiro/agents/` に移行する必要がある

## Testing Strategy

- setup.shを実行し、`~/.kiro/agents/` に設定ファイルが正しく生成されることを確認
- 生成された設定ファイルでkiro-cliが正常に動作することを確認

---
**Created**: 2025-11-22
