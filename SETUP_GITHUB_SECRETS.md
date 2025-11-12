# GitHub Secrets セットアップガイド

## Cursor APIキーの登録

### 方法1: GitHub CLIで登録（推奨）

```bash
# Cursor APIキーをリポジトリに登録
gh secret set CURSOR_API_KEY --repo tai29/cleanup_logs --body "$CURSOR_API_KEY"

# 確認
gh secret list --repo tai29/cleanup_logs
```

### 方法2: GitHub Web UIで登録

1. リポジトリページにアクセス: https://github.com/tai29/cleanup_logs
2. Settings → Secrets and variables → Actions
3. 「New repository secret」をクリック
4. Name: `CURSOR_API_KEY`
5. Secret: あなたのCursor APIキー
6. 「Add secret」をクリック

## Webhook Secret（オプション）

Webhook連携を使用する場合:

```bash
gh secret set CURSOR_WEBHOOK_SECRET --repo tai29/cleanup_logs --body "YOUR_SIGNING_SECRET"
```

## 確認

登録されたSecretsを確認:

```bash
gh secret list --repo tai29/cleanup_logs
```

## 使用方法

GitHub Actionsワークフロー（`.github/workflows/cursor-agent.yml`）で自動的に使用されます。

GitHub Actionsのページから「Cursor Agent」ワークフローを手動実行する際に、Secretsが自動的に読み込まれます。

