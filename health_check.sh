#!/bin/bash

# 1コマンド健康診断（困ったら叩く）

echo "=== 健康診断 ==="
echo ""

echo "【1】スケジュール確認"
echo "----------------------------------------"
launchctl list | grep -E 'desktop.cleanup|downloads.cleanup' || echo "  ⚠️  スケジュールが見つかりません"

echo ""
echo "【2】ディスク容量"
echo "----------------------------------------"
df -h / | tail -1

echo ""
echo "【3】エラーログ確認"
echo "----------------------------------------"
error_count=$(grep -E 'ERROR|WARN|FAILED' ~/Documents/cleanup_logs/* 2>/dev/null | wc -l | tr -d ' ')
if [ "$error_count" -gt 0 ]; then
    echo "⚠️  エラー/警告が $error_count 件見つかりました:"
    grep -E 'ERROR|WARN|FAILED' ~/Documents/cleanup_logs/* 2>/dev/null | tail -20
else
    echo "✅ エラー/警告は見つかりませんでした"
fi

echo ""
echo "【4】Archive容量"
echo "----------------------------------------"
echo "Desktop Archive:"
du -sh ~/Desktop/_Archive 2>/dev/null || echo "  存在しません"
echo "Downloads Archive:"
du -sh ~/Downloads/_Archive 2>/dev/null || echo "  存在しません"

echo ""
echo "✅ 健康診断完了"

