#!/bin/bash

# 動作確認スクリプト（30秒）

echo "=== 動作確認 ==="
echo ""

echo "【1】通知テスト"
echo "----------------------------------------"
osascript -e 'display notification "通知テスト" with title "Cleanup"' 2>/dev/null && echo "✅ 通知が表示されました" || echo "⚠️  通知の表示に失敗しました"

echo ""
echo "【2】承認TTLテスト"
echo "----------------------------------------"
if [ -f ~/.approve_maintenance ]; then
    timestamp=$(cat ~/.approve_maintenance)
    now=$(date +%s)
    elapsed=$((now - timestamp))
    remaining=$((900 - elapsed))
    
    if [ "$elapsed" -lt 900 ]; then
        echo "✅ 承認ファイルは有効です（残り ${remaining}秒）"
    else
        echo "⚠️  承認ファイルは期限切れです（${elapsed}秒経過）"
    fi
    echo "タイムスタンプ: $timestamp ($(date -r "$timestamp" 2>/dev/null || echo "無効"))"
else
    echo "ℹ️  承認ファイルが存在しません"
fi

echo ""
echo "【3】チェックサム確認"
echo "----------------------------------------"
if [ -f ~/Documents/cleanup_logs/.checksums ]; then
    echo "✅ チェックサムファイルが存在します"
    echo "内容:"
    cat ~/Documents/cleanup_logs/.checksums | grep -v "^#"
else
    echo "⚠️  チェックサムファイルが見つかりません"
fi

echo ""
echo "【4】スケジュール確認"
echo "----------------------------------------"
launchctl list | grep -E 'desktop.cleanup|downloads.cleanup|monthly.check|restore_drill|quarterly.archive' | awk '{print "  ✅ " $3}' || echo "  ⚠️  スケジュールが見つかりません"

echo ""
echo "✅ 動作確認完了"

