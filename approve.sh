#!/bin/bash

# 承認トークンを15分だけ有効化

echo "$(date +%s)" > ~/.approve_maintenance
echo "✅ 承認ファイルを作成しました（15分間有効）"
echo "15分後に自動削除されます"

# バックグラウンドで15分後に削除
(sleep 900; rm -f ~/.approve_maintenance && echo "承認ファイルを削除しました" 2>/dev/null) &

