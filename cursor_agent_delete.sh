#!/bin/bash

# Cursor Agent を削除するスクリプト
# 使用方法: ./cursor_agent_delete.sh <agent_id>

set -euo pipefail

# 環境変数チェック
if [ -z "${CURSOR_API_KEY:-}" ]; then
    echo "❌ エラー: CURSOR_API_KEY 環境変数が設定されていません"
    exit 1
fi

# 引数チェック
if [ $# -eq 0 ]; then
    echo "❌ エラー: Agent IDが指定されていません"
    echo ""
    echo "使用方法:"
    echo "  ./cursor_agent_delete.sh <agent_id>"
    echo ""
    echo "例:"
    echo "  ./cursor_agent_delete.sh agent_xxx"
    exit 1
fi

AGENT_ID="$1"
API_URL="https://api.cursor.com/v0/agents/$AGENT_ID"

echo "🗑️  エージェントを削除中: $AGENT_ID"
echo ""

RESPONSE=$(curl -s -X DELETE \
  -H "Authorization: Bearer $CURSOR_API_KEY" \
  "$API_URL")

if [ -z "$RESPONSE" ] || echo "$RESPONSE" | grep -q "deleted\|success"; then
    echo "✅ エージェントを削除しました"
else
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
fi

