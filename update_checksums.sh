#!/bin/bash

# チェックサム更新スクリプト（スクリプト改変時の正しい手順）

set -euo pipefail

CHECKSUM_FILE="$HOME/Documents/cleanup_logs/.checksums"
BACKUP_FILE="$HOME/Documents/cleanup_logs/.checksums.bak"

echo "=== チェックサム更新 ==="
echo ""

# バックアップ作成
if [ -f "$CHECKSUM_FILE" ]; then
    cp "$CHECKSUM_FILE" "$BACKUP_FILE"
    echo "✅ バックアップを作成しました: $BACKUP_FILE"
fi

# 新しいハッシュ値を計算
echo "新しいハッシュ値を計算中..."
echo ""

desktop_hash=$(shasum -a 256 ~/Desktop/cleanup_desktop.sh 2>/dev/null | awk '{print $1}')
downloads_hash=$(shasum -a 256 ~/Downloads/cleanup_downloads.sh 2>/dev/null | awk '{print $1}')

if [ -z "$desktop_hash" ] || [ -z "$downloads_hash" ]; then
    echo "❌ エラー: スクリプトファイルが見つかりません"
    exit 1
fi

# チェックサムファイルを更新
{
    echo "# スクリプトのハッシュ値（改ざん検知用）"
    echo "# 更新日: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "sha256  $desktop_hash  cleanup_desktop.sh"
    echo "sha256  $downloads_hash  cleanup_downloads.sh"
} > "$CHECKSUM_FILE"

echo "✅ チェックサムを更新しました:"
echo ""
cat "$CHECKSUM_FILE" | grep -v "^#"
echo ""
echo "誤って更新した場合は以下で復元:"
echo "  cp $BACKUP_FILE $CHECKSUM_FILE"

