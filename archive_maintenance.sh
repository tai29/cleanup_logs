#!/bin/bash

# 保持ポリシー実行（6か月で圧縮→12か月で削除）

set -euo pipefail

# 安全装置：承認ファイル必須（TTL付き：15分以内のみ有効）
notify() {
    osascript -e "display notification \"$1\" with title \"Cleanup\"" 2>/dev/null || true
}

now=$(date +%s)
t=$(cat "$HOME/.approve_maintenance" 2>/dev/null || echo "0")
if [ ! -f "$HOME/.approve_maintenance" ] || [ $((now - t)) -gt 900 ]; then
    echo "[BLOCK] 承認ファイルが必要です、または期限切れです: ~/.approve_maintenance"
    echo "実行する場合: ~/Documents/cleanup_logs/approve.sh"
    echo "承認は15分間のみ有効です"
    notify "承認が必要です"
    exit 0
fi

echo "=== Archive保守 ==="
echo ""

echo "【1】6か月超のArchiveを圧縮"
echo "----------------------------------------"
find ~/Desktop/_Archive ~/Downloads/_Archive -type d -maxdepth 1 -mtime +180 2>/dev/null | while IFS= read -r dir; do
    [ -z "$dir" ] && continue
    [ "$(basename "$dir")" = "_Archive" ] && continue
    
    archive_name=$(basename "$dir")
    parent_dir=$(dirname "$dir")
    
    echo "圧縮中: $archive_name"
    cd "$parent_dir"
    tar -czf "${archive_name}.tar.gz" "$archive_name" 2>/dev/null && \
        rm -rf "$archive_name" && \
        echo "  ✅ 圧縮完了: ${archive_name}.tar.gz" || \
        echo "  ⚠️  圧縮失敗: $archive_name"
done

echo ""
echo "【2】12か月超の圧縮ファイルを削除"
echo "----------------------------------------"
deleted_count=0
find ~/Desktop/_Archive ~/Downloads/_Archive -type f -name "*.tar.gz" -mtime +365 2>/dev/null | while IFS= read -r file; do
    [ -z "$file" ] && continue
    echo "削除: $(basename "$file")"
    rm -f "$file" && deleted_count=$((deleted_count + 1))
done

echo ""
echo "✅ Archive保守完了"
echo "  削除された圧縮ファイル: $deleted_count 件"

# 通知
notify "Archive保守完了"

