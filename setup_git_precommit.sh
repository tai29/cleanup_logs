#!/bin/bash

# Git系の追加安全網（コミット前フックで大容量誤登録をブロック）

set -euo pipefail

if [ ! -d .git ]; then
    echo "❌ エラー: .gitディレクトリが見つかりません"
    echo "   このスクリプトはGitリポジトリのルートで実行してください"
    exit 1
fi

echo "=== Git pre-commitフックの設定 ==="
echo ""

cat > .git/hooks/pre-commit <<'EOS'
#!/bin/sh

limit=$((50*1024*1024)) # 50MB

git diff --cached --name-only | while read f; do
  [ -f "$f" ] || continue
  sz=$(wc -c <"$f" 2>/dev/null || echo "0")
  [ "$sz" -ge "$limit" ] && {
    echo "❌ BLOCK: $f is $(($sz/1024/1024))MB (50MB制限)"
    exit 1
  }
done
EOS

chmod +x .git/hooks/pre-commit

echo "✅ pre-commitフックを設定しました"
echo "   50MB以上のファイルのコミットをブロックします"

