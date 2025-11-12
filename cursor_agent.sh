#!/bin/bash

# Cursor Cloud/Background Agents API クイック実行スクリプト
# 使用方法: ./cursor_agent.sh "プロンプト内容"

set -euo pipefail

# 環境変数チェック
if [ -z "${CURSOR_API_KEY:-}" ]; then
    echo "❌ エラー: CURSOR_API_KEY 環境変数が設定されていません"
    echo ""
    echo "設定方法:"
    echo "  export CURSOR_API_KEY=\"あなたのキー\""
    exit 1
fi

# プロンプトチェック
if [ $# -eq 0 ]; then
    echo "❌ エラー: プロンプトが指定されていません"
    echo ""
    echo "使用方法:"
    echo "  ./cursor_agent.sh \"プロンプト内容\""
    echo ""
    echo "例:"
    echo "  ./cursor_agent.sh \"README.mdを改善して\""
    exit 1
fi

PROMPT="$1"
REPO="https://github.com/tai29/cleanup_logs"
BRANCH="main"
API_URL="https://api.cursor.com/v0/agents"

echo "🚀 Cursor Agent を起動中..."
echo "   リポジトリ: $REPO"
echo "   ブランチ: $BRANCH"
echo "   プロンプト: $PROMPT"
echo ""

# エージェント起動
RESPONSE=$(curl -s --request POST \
  --url "$API_URL" \
  --header "Authorization: Bearer $CURSOR_API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
    \"prompt\": { \"text\": \"$PROMPT\" },
    \"source\": { \"repository\": \"$REPO\", \"ref\": \"$BRANCH\" },
    \"target\": { \"autoCreatePr\": true }
  }")

# レスポンス解析
AGENT_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*' | cut -d'"' -f4 || echo "")
STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*' | cut -d'"' -f4 || echo "")
PR_URL=$(echo "$RESPONSE" | grep -o '"url":"[^"]*' | cut -d'"' -f4 || echo "")

if [ -n "$AGENT_ID" ]; then
    echo "✅ エージェント起動成功！"
    echo "   Agent ID: $AGENT_ID"
    echo "   ステータス: $STATUS"
    if [ -n "$PR_URL" ]; then
        echo "   PR URL: $PR_URL"
    fi
    echo ""
    echo "進捗確認:"
    echo "  curl -H \"Authorization: Bearer \$CURSOR_API_KEY\" \\"
    echo "    https://api.cursor.com/v0/agents/$AGENT_ID"
    echo ""
    echo "会話ログ:"
    echo "  curl -H \"Authorization: Bearer \$CURSOR_API_KEY\" \\"
    echo "    https://api.cursor.com/v0/agents/$AGENT_ID/conversation"
else
    echo "❌ エラー: エージェント起動に失敗しました"
    echo ""
    echo "レスポンス:"
    echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
    exit 1
fi
