#!/bin/bash

# "勝手に消えない"最終確認

echo "=== 安全装置の確認 ==="
echo ""

echo "【1】承認なしで実行（BLOCKされるはず）"
echo "----------------------------------------"
rm -f ~/.approve_maintenance 2>/dev/null || true
result=$(~/Documents/cleanup_logs/archive_maintenance.sh 2>&1 | grep -E 'BLOCK|approval' || echo "")

if echo "$result" | grep -q "BLOCK\|approval"; then
    echo "✅ 安全装置が機能しています"
    echo "$result"
else
    echo "⚠️  安全装置の確認に失敗しました"
fi

echo ""
echo "【2】承認ファイル作成後の確認"
echo "----------------------------------------"
~/Documents/cleanup_logs/approve.sh
if [ -f ~/.approve_maintenance ]; then
    echo "✅ 承認ファイルが作成されました"
    echo "   15分後に自動削除されます"
else
    echo "⚠️  承認ファイルの作成に失敗しました"
fi

echo ""
echo "✅ 安全装置確認完了"

