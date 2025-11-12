#!/bin/bash

# 定常の見るべき場所（週1で10秒）

echo "=== 定常チェック（週1で10秒） ==="
echo ""

echo "【1】Desktop整理レポート"
echo "----------------------------------------"
tail -40 ~/Desktop/Cleanup-Report.out 2>/dev/null || echo "  レポートが見つかりません"

echo ""
echo "【2】Downloads整理レポート"
echo "----------------------------------------"
tail -40 ~/Documents/cleanup_logs/downloads.out 2>/dev/null || echo "  レポートが見つかりません"

echo ""
echo "【3】スケジュール確認"
echo "----------------------------------------"
launchctl list | grep -E 'desktop.cleanup|downloads.cleanup|monthly.check|restore_drill|quarterly.archive' | awk '{print "  ✅ " $3}' || echo "  ⚠️  スケジュールが見つかりません"

echo ""
echo "✅ 定常チェック完了"

