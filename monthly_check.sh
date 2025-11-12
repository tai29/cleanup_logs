#!/bin/bash

# 月1チェック（60秒）

echo "=== 月1チェック ==="
echo ""

echo "【1】直近DRYレポート"
echo "----------------------------------------"
tail -n +1 ~/Desktop/Cleanup-Report.out ~/Documents/cleanup_logs/downloads.out 2>/dev/null | tail -80 || echo "レポートが見つかりません"

echo ""
echo "【2】退避量の推移（容量の暴れ検知）"
echo "----------------------------------------"
echo "Desktop Archive:"
du -sh ~/Desktop/_Archive/* 2>/dev/null | sort -h | tail || echo "  Archiveが見つかりません"

echo ""
echo "Downloads Archive:"
du -sh ~/Downloads/_Archive/* 2>/dev/null | sort -h | tail || echo "  Archiveが見つかりません"

echo ""
echo "【3】ログ回転（肥大防止）"
echo "----------------------------------------"
log_rotated=0
find ~/Documents/cleanup_logs -type f -name "*.log" -size +5M 2>/dev/null | while IFS= read -r logfile; do
    echo "削除: $(basename "$logfile") ($(du -h "$logfile" | cut -f1))"
    rm -f "$logfile" && log_rotated=$((log_rotated + 1))
done
[ "$log_rotated" -gt 0 ] && echo "  ✅ $log_rotated 件のログを削除しました" || echo "  削除対象なし"

echo ""
echo "【4】ログの総量制限（肥大防止）"
echo "----------------------------------------"
TOTAL=$(du -sk ~/Documents/cleanup_logs 2>/dev/null | awk '{print $1}' || echo "0")
TOTAL_MB=$((TOTAL / 1024))
echo "ログ総量: ${TOTAL_MB}MB"

if [ "$TOTAL" -gt 204800 ]; then
    echo "⚠️  ログ総量が200MBを超えています。古いログを削除します"
    deleted_count=0
    ls -tr ~/Documents/cleanup_logs/*.log ~/Documents/cleanup_logs/*.out ~/Documents/cleanup_logs/*.err 2>/dev/null | head -50 | while IFS= read -r file; do
        [ -f "$file" ] && rm -f "$file" && deleted_count=$((deleted_count + 1))
    done
    echo "  ✅ 古いログを削除しました"
else
    echo "  ✅ ログ総量は正常範囲内です"
fi

echo ""
echo "✅ 月1チェック完了"

