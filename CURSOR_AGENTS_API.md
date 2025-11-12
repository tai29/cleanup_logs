# Cursor Cloud/Background Agents API 最短手順

## 0) 事前準備（1分）

### APIキー発行
1. Cursor ダッシュボード → Integrations → User API Keys で作成
2. 環境変数に設定：
```bash
export CURSOR_API_KEY="あなたのキー"
```

### 課金設定
- Cloud/Background Agent は選択モデルのAPI料金で従量課金
- 初回に利用上限の設定が求められる

### 対象リポジトリ
- GitHub リポジトリと紐付けて動作（PR作成まで自動）
- リポジトリ: `https://github.com/tai29/cleanup_logs`

---

## 1) エージェント起動（Launch）

```bash
# リポジトリ main ブランチに対して「README改善」をやらせる例
curl --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "prompt": { "text": "リポジトリにREADME.mdを改善し、セットアップ手順と運用フローを詳しく書いて" },
    "source": { "repository": "https://github.com/tai29/cleanup_logs", "ref": "main" },
    "target": { "autoCreatePr": true }
  }'
```

**成功レスポンス例:**
```json
{
  "id": "agent_xxx",
  "status": "CREATING",
  "target": {
    "branchName": "cursor-agent-xxx",
    "url": "https://github.com/tai29/cleanup_logs/pull/1"
  }
}
```

**ステータス遷移:** `CREATING` → `RUNNING` → `COMPLETED`

---

## 2) 進捗取得・会話ログ・一覧

### エージェント一覧
```bash
curl -H "Authorization: Bearer $CURSOR_API_KEY" \
  https://api.cursor.com/v0/agents
```

### 会話ログ（思考とアクション履歴）
```bash
# {id} は起動時に返された agent ID
curl -H "Authorization: Bearer $CURSOR_API_KEY" \
  https://api.cursor.com/v0/agents/{id}/conversation
```

### 特定エージェントの詳細
```bash
curl -H "Authorization: Bearer $CURSOR_API_KEY" \
  https://api.cursor.com/v0/agents/{id}
```

---

## 3) フォローアップ（追い指示）

```bash
curl --request POST \
  --url https://api.cursor.com/v0/agents/{id}/followup \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "prompt": { "text": "READMEにトラブルシューティング章を追加して" }
  }'
```

**注意:** 実行中のエージェントに追い指示可能。PR完了後は新規起動＋別PRが推奨。

---

## 4) 後始末（削除）

```bash
curl -X DELETE \
  -H "Authorization: Bearer $CURSOR_API_KEY" \
  https://api.cursor.com/v0/agents/{id}
```

エージェントと付随リソースを完全削除。

---

## 5) Webhook（状態変化の通知）

起動時に `webhook` URL を渡すと、`statusChange` を POST で受けられる。

```bash
curl --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "prompt": { "text": "READMEを改善して" },
    "source": { "repository": "https://github.com/tai29/cleanup_logs", "ref": "main" },
    "target": { "autoCreatePr": true },
    "webhook": { "url": "https://your-webhook-endpoint.com/cursor" }
  }'
```

---

## 6) クイック実行スクリプト

`cursor_agent.sh` を使用：

```bash
export CURSOR_API_KEY="あなたのキー"
./cursor_agent.sh "README.mdを改善して"
```

---

## 7) 実際の使用例（cleanup_logs向け）

### README改善
```bash
curl --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "prompt": { "text": "README.mdを改善し、各スクリプトの詳細な説明、使用方法、注意事項を追加して" },
    "source": { "repository": "https://github.com/tai29/cleanup_logs", "ref": "main" },
    "target": { "autoCreatePr": true }
  }'
```

### ドキュメント追加
```bash
curl --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "prompt": { "text": "docs/ ディレクトリを作成し、各スクリプトの詳細なドキュメントをMarkdown形式で追加して" },
    "source": { "repository": "https://github.com/tai29/cleanup_logs", "ref": "main" },
    "target": { "autoCreatePr": true }
  }'
```

---

## 参考リンク

- [Background Agents API 概要](https://docs.cursor.com/api/cloud-agents)
- [Cloud/Background Agents の説明](https://docs.cursor.com/agents/cloud-agents)
- [API 総合案内](https://docs.cursor.com/api)
