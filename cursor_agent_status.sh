#!/bin/bash

# Cursor Agent の状態確認スクリプト
# 使用方法: ./cursor_agent_status.sh [agent_id]

set -euo pipefail

# 環境変数チェック
if [ -z "${CURSOR_API_KEY:-}" ]; then
    echo "❌ エラー: CURSOR_API_KEY 環境変数が設定されていません"
    exit 1
fi

API_URL="https://api.cursor.com/v0/agents"

# エージェントIDが指定されている場合
if [ $# -eq 1 ]; then
    AGENT_ID="$1"
    echo "📊 エージェント詳細: $AGENT_ID"
    echo ""
    
    # エージェント詳細
    curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL/$AGENT_ID" | jq '.' 2>/dev/null || \
      curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL/$AGENT_ID"
    
    echo ""
    echo "💬 会話ログ:"
    curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL/$AGENT_ID/conversation" | jq '.' 2>/dev/null || \
      curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL/$AGENT_ID/conversation"
else
    # エージェント一覧
    echo "📋 エージェント一覧:"
    echo ""
    curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL" | jq '.' 2>/dev/null || \
      curl -s -H "Authorization: Bearer $CURSOR_API_KEY" \
      "$API_URL"
fi

