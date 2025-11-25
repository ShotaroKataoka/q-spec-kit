# Q-SPECによる推測ヒアリングベースの仕様策定フレームワーク

## 🎯 概要

### 核となる理論

- **ALL YOU NEED is SPEC (AYNiS)**: 全ての作業をSPEC駆動で管理する
- **Q-SPEC Framework**: AIエージェントによる推測ヒアリング仕様策定フレームワーク
- **SPEC as an Asset**: SPECを知識資産として再利用する

## 🚀 クイックスタート

### 1. リポジトリのクローン

```bash
git clone git@github.com:ShotaroKataoka/q-spec-kit.git
cd q-spec-kit
```

### 2. セットアップ実行

```bash
./setup.sh
```

セットアップスクリプトが以下を自動実行します：
- エージェント名の選択（複数エージェント対応）
- カスタムエージェント設定の生成
- 推奨MCPサーバーの選択（オプション）
- `~/.kiro/agents/`への配置
- シェルエイリアスの設定（オプション）

### 3. エージェント起動

```bash
kiro-cli chat --agent dev-agent
# または設定したエイリアス（例: qcd）
```

### 魔法の言葉
以下のワードはエージェントのコンテキストを刺激できるため効果的です。

- Q-SPECでお願いします
- SPECをクローズして
- notes.mdを更新して
- 調査SPECでOOの実現可能性を調査して
- close & commit

## 🔧 カスタマイズ

### エージェント設定の調整

`~/.kiro/agents/dev-agent.json`を編集：
- 許可コマンドの追加・削除
- ファイル書き込み範囲の調整
- リソース読み込みの変更

`path/to/q-spec-kit/contexts/user_preference_*.md`を編集:
- エージェントごとのユーザ用コンテキストです
- エージェントの振る舞いを調整したい時に自由に編集してください


## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成
3. 変更をコミット
4. プルリクエストを作成

## 📄 ライセンス

MIT License

## 🆘 サポート

- **Issues**: バグ報告・機能要望
- **Discussions**: 使用方法・ベストプラクティス
- **Wiki**: 詳細ドキュメント・チュートリアル

---

**Happy coding with Q-SPEC Kit! 🎉**
