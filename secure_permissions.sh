#!/bin/bash

# 権限の締め（承認ファイルののぞき見防止）

echo "=== 権限の締め ==="
echo ""

# 承認ファイルの権限を600に設定
if [ -f ~/.approve_maintenance ]; then
    chmod 600 ~/.approve_maintenance
    echo "✅ 承認ファイルの権限を600に設定しました"
else
    echo "ℹ️  承認ファイルが存在しません（次回作成時に自動適用）"
fi

# チェックサムファイルの権限も締める
if [ -f ~/Documents/cleanup_logs/.checksums ]; then
    chmod 600 ~/Documents/cleanup_logs/.checksums
    echo "✅ チェックサムファイルの権限を600に設定しました"
fi

echo ""
echo "【.zshrcへの追加（任意）】"
echo "----------------------------------------"
echo "より堅牢にする場合、以下を ~/.zshrc に追加:"
echo "  umask 077  # デフォルト権限を厳しく"
echo ""
echo "✅ 権限の締め完了"

