# クイックスタートガイド

## セットアップ（5分）

### 1. リポジトリのクローン

```bash
git clone https://github.com/tai29/cleanup_logs.git
cd cleanup_logs
```

### 2. 環境変数の設定

```bash
# .env.example をコピー
cp .env.example .env

# エディタで .env を開いて CURSOR_API_KEY を設定
# Cursor ダッシュボード → Integrations → User API Keys で取得
```

または直接環境変数に設定：

```bash
export CURSOR_API_KEY="あなたのキー"
```

### 3. スクリプトに実行権限を付与

```bash
chmod +x *.sh
```

## 基本的な使い方

### Cursor Agent でリポジトリを改善

```bash
# READMEを改善
./cursor_agent.sh "README.mdを改善して"

# ドキュメントを追加
./cursor_agent.sh "docs/ に各スクリプトの詳細ドキュメントを追加して"

# コードをリファクタリング
./cursor_agent.sh "すべてのシェルスクリプトにエラーハンドリングを追加して"
```

### エージェントの状態確認

```bash
# すべてのエージェント一覧
./cursor_agent_status.sh

# 特定のエージェントの詳細
./cursor_agent_status.sh agent_xxx
```

### フォローアップ指示

```bash
./cursor_agent_followup.sh agent_xxx "追加の改善をして"
```

### エージェントの削除

```bash
./cursor_agent_delete.sh agent_xxx
```

## よくある使用例

### 1. プロジェクトのドキュメント化

```bash
./cursor_agent.sh "docs/ ディレクトリを作成し、各スクリプトの使用方法、パラメータ、注意事項をMarkdown形式で詳しく書いて"
```

### 2. コード品質の向上

```bash
./cursor_agent.sh "すべてのシェルスクリプトをレビューし、ベストプラクティスに従って改善して。エラーハンドリング、ログ出力、コメントを追加して"
```

### 3. テストの追加

```bash
./cursor_agent.sh "各スクリプトのテストスクリプトを作成して。tests/ ディレクトリに配置して"
```

### 4. CI/CDの設定

```bash
./cursor_agent.sh ".github/workflows/ にCI/CDワークフローを追加して。シェルスクリプトの構文チェックとlintを実行するようにして"
```

## トラブルシューティング

### APIキーが無効

```bash
# 認証確認
curl -H "Authorization: Bearer $CURSOR_API_KEY" \
  https://api.cursor.com/v0/me
```

### エージェントが起動しない

1. APIキーが正しく設定されているか確認
2. リポジトリURLが正しいか確認（https://github.com/tai29/cleanup_logs）
3. ネットワーク接続を確認

### PRが作成されない

- `target.autoCreatePr: true` が設定されているか確認
- GitHubのリポジトリ設定でブランチ保護が有効になっていないか確認

## 次のステップ

- [CURSOR_AGENTS_API.md](../CURSOR_AGENTS_API.md) で詳細なAPI仕様を確認
- [README.md](../README.md) でプロジェクト全体の概要を確認
- `.cursorrules` でプロジェクトのコーディング規約を確認

