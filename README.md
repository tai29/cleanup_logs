# Cleanup Logs プロジェクト

ファイル整理とクリーンアップの自動化スクリプト集です。

## 概要

このプロジェクトは、デスクトップやダウンロードフォルダの自動整理、定期メンテナンス、バックアップ、復元機能を提供するシェルスクリプトのコレクションです。

## 主な機能

- **自動整理**: デスクトップとダウンロードフォルダの自動整理
- **定期メンテナンス**: 月次・四半期ごとのアーカイブ処理
- **復元機能**: 誤って削除したファイルの復元
- **ヘルスチェック**: システムの状態確認とログ監視
- **セキュリティ**: ファイル権限の確認と修正

## ファイル構成

### メインスクリプト
- `final_check.sh`: 最終チェックスクリプト
- `monthly_check.sh`: 月次チェックスクリプト
- `archive_maintenance.sh`: アーカイブメンテナンス
- `emergency_recovery.sh`: 緊急復元スクリプト
- `health_check.sh`: ヘルスチェック
- `verify_safety.sh`: 安全性検証
- `verify_system.sh`: システム検証

### Cursor Agent管理スクリプト
- `cursor_agent.sh`: エージェント起動スクリプト
- `cursor_agent_status.sh`: エージェント状態確認スクリプト
- `cursor_agent_followup.sh`: エージェントにフォローアップ指示を送るスクリプト
- `cursor_agent_delete.sh`: エージェント削除スクリプト

### ドキュメント
- `CURSOR_AGENTS_API.md`: Cursor Cloud/Background Agents API の詳細ドキュメント
- `.cursorrules/`: Cursor AI 用のプロジェクトルール（ディレクトリ構造）

## 使用方法

### 通常のスクリプト
各スクリプトの詳細は、各ファイル内のコメントを参照してください。

### Cursor Agent の使用
1. APIキーを設定:
```bash
export CURSOR_API_KEY="あなたのキー"
```

2. エージェントを起動:
```bash
./cursor_agent.sh "README.mdを改善して"
```

3. 状態を確認:
```bash
./cursor_agent_status.sh
# または特定のエージェント
./cursor_agent_status.sh <agent_id>
```

4. フォローアップ指示:
```bash
./cursor_agent_followup.sh <agent_id> "追加の指示"
```

詳細は `CURSOR_AGENTS_API.md` を参照してください。

## クイックスタート

詳細なセットアップ手順は [docs/QUICKSTART.md](docs/QUICKSTART.md) を参照してください。

### 前提条件

Makefileを使用する場合、以下のツールが必要です：

- `shellcheck`: シェルスクリプトのlint
- `shfmt`: シェルスクリプトのフォーマッタ
- `jq`: JSON処理（Cursor Agentスクリプトで使用）
- `curl`: HTTPリクエスト（Cursor Agentスクリプトで使用）

インストール例（macOS）:
```bash
brew install shellcheck shfmt jq
# curlは通常プリインストール済み
```

### 基本的な使い方

```bash
# 1. 環境変数を設定
export CURSOR_API_KEY="あなたのキー"

# 2. エージェントを起動
./cursor_agent.sh "README.mdを改善して"

# または Makefile を使用
make agent
```

### 開発ツールの使用

```bash
make lint    # シェルスクリプトのlint
make fmt     # フォーマット
make test    # 構文チェック
make clean   # 一時ファイル削除
```

## ドキュメント

- [クイックスタートガイド](docs/QUICKSTART.md) - 5分で始める
- [Cursor Agents API詳細](CURSOR_AGENTS_API.md) - API仕様
- [コントリビューションガイド](docs/CONTRIBUTING.md) - 貢献方法

## 注意事項

- 実行前に必ずバックアップを取ってください
- 本番環境で使用する前にテスト環境で動作確認を行ってください
- `.env` ファイルには機密情報を含めないでください（`.env.example` を参照）

