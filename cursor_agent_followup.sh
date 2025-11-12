#!/bin/bash

# Cursor Agent にフォローアップ指示を送るスクリプト
# 使用方法: ./cursor_agent_followup.sh <agent_id> "プロンプト内容"

set -euo pipefail

# 環境変数チェック
if [ -z "${CURSOR_API_KEY:-}" ]; then
    echo "❌ エラー: CURSOR_API_KEY 環境変数が設定されていません"
    exit 1
fi

# 引数チェック
if [ $# -lt 2 ]; then
    echo "❌ エラー: 引数が不足しています"
    echo ""
    echo "使用方法:"
    echo "  ./cursor_agent_followup.sh <agent_id> \"プロンプト内容\""
    echo ""
    echo "例:"
    echo "  ./cursor_agent_followup.sh agent_xxx \"READMEにトラブルシューティング章を追加して\""
    exit 1
fi

AGENT_ID="$1"
PROMPT="$2"
API_URL="https://api.cursor.com/v0/agents/$AGENT_ID/followup"

echo "📝 フォローアップ指示を送信中..."
echo "   Agent ID: $AGENT_ID"
echo "   プロンプト: $PROMPT"
echo ""

RESPONSE=$(curl -s --request POST \
  --url "$API_URL" \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
    \"prompt\": { \"text\": \"$PROMPT\" }
  }")

echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"

