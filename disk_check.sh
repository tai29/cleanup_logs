#!/bin/bash

# 詰まりの早期検知（iCloud/容量対策）

echo "=== ディスク容量チェック ==="
echo ""

# 空き容量チェック（10GB未満なら警告）
free_space_kb=$(df -Pk / | awk 'NR==2{print $4}')
free_space_gb=$((free_space_kb / 1024 / 1024))

echo "空き容量: ${free_space_gb}GB"

if [ "$free_space_kb" -lt 10485760 ]; then
    echo "⚠️  [WARN] Low disk space (10GB未満)"
    echo ""
    echo "対処方法:"
    echo "  1. _Archiveを圧縮: ~/Documents/cleanup_logs/archive_maintenance.sh"
    echo "  2. iCloud対象なら _Archive を iCloud外へ退避:"
    echo "     mv ~/Desktop/_Archive ~/Documents/DesktopArchive"
    echo "     mv ~/Downloads/_Archive ~/Documents/DownloadsArchive"
else
    echo "✅ 空き容量は十分です"
fi

echo ""
echo "【iCloud対象フォルダの確認】"
if [ -d ~/Library/Mobile\ Documents/com~apple~CloudDocs ]; then
    echo "  iCloudが有効です"
    echo "  _ArchiveをiCloud外に移動することを推奨します"
else
    echo "  iCloudは無効です"
fi

