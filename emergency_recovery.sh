#!/bin/bash

# 非常時の標準手順

echo "=== 非常時復旧手順 ==="
echo ""

echo "【1】直近ログを確認"
echo "----------------------------------------"
echo "直近100行を表示:"
tail -100 ~/Documents/cleanup_logs/*.out 2>/dev/null | tail -50 || echo "  ログファイルが見つかりません"

echo ""
echo "【2】巻き戻し"
echo "----------------------------------------"
echo "実行: ~/Desktop/restore_last_cleanup.sh"
echo ""
read -p "巻き戻しを実行しますか？ (y/N): " answer
if [ "$answer" = "y" ]; then
    ~/Desktop/restore_last_cleanup.sh
else
    echo "  スキップしました"
fi

echo ""
echo "【3】Time Machineからの復元"
echo "----------------------------------------"
echo "それでも戻らない場合:"
echo "  1. Time Machineアイコンをクリック"
echo "  2. 削除前の日時に戻る"
echo "  3. 該当フォルダ（/Documents または /Downloads）を復元"
echo ""
echo "✅ 非常時復旧手順の確認完了"

