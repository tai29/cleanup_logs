#!/bin/bash

# Keepbox の Git 管理（初期化ワンショット）

set -euo pipefail

KEEPBOX="$HOME/Documents/Keepbox"

echo "=== Keepbox Git管理の初期化 ==="
echo ""

mkdir -p "$KEEPBOX"
cd "$KEEPBOX"

# Git初期化
if [ -d .git ]; then
    echo "⚠️  既にGitリポジトリです"
else
    git init
    echo "✅ Gitリポジトリを初期化しました"
fi

# .gitignore作成
if [ ! -f .gitignore ]; then
    cat > .gitignore <<'EOS'
*.zip
*.gpg
Sensitive-*.zip
*.tmp
*.swp
*.log
.DS_Store
EOS
    echo "✅ .gitignoreを作成しました"
fi

# 初回コミット
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ コミットする変更はありません"
else
    git add -A
    git commit -m "init keepbox"
    echo "✅ 初回コミットを作成しました"
fi

echo ""
echo "非公開リモートを追加する場合:"
echo "  cd $KEEPBOX"
echo "  git remote add origin <ssh-url>"
echo "  git push -u origin main"

echo ""
echo "✅ Keepbox Git管理の初期化が完了しました"

