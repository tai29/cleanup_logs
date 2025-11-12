#!/bin/bash

# Keepboxをgit管理＋リモート非公開リポジトリに初期化

set -euo pipefail

KEEPBOX="$HOME/Documents/Keepbox"
REMOTE_URL="${1:-}"

echo "=== Keepbox Git管理の初期化 ==="
echo ""

if [ ! -d "$KEEPBOX" ]; then
    echo "❌ Keepboxディレクトリが見つかりません: $KEEPBOX"
    exit 1
fi

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
# 一時ファイル
*.tmp
*.swp
*.log
.DS_Store

# 暗号化ファイル（既に暗号化済み）
*_encrypted.zip
*.gpg

# 個人情報（必要に応じて追加）
# *password*
# *secret*
EOS
    echo "✅ .gitignoreを作成しました"
fi

# pre-commitフック設定
if [ -f ../cleanup_logs/setup_git_precommit.sh ]; then
    bash ../cleanup_logs/setup_git_precommit.sh
else
    echo "⚠️  pre-commitフックの設定をスキップしました"
fi

# 初回コミット
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ コミットする変更はありません"
else
    git add .
    git commit -m "Initial commit: Keepbox templates and assets"
    echo "✅ 初回コミットを作成しました"
fi

# リモート設定（オプション）
if [ -n "$REMOTE_URL" ]; then
    git remote add origin "$REMOTE_URL" 2>/dev/null || \
        git remote set-url origin "$REMOTE_URL"
    echo "✅ リモートリポジトリを設定しました: $REMOTE_URL"
    echo ""
    echo "次に実行:"
    echo "  cd $KEEPBOX"
    echo "  git push -u origin main"
else
    echo ""
    echo "リモートリポジトリを設定する場合:"
    echo "  cd $KEEPBOX"
    echo "  git remote add origin <your-private-repo-url>"
    echo "  git push -u origin main"
fi

echo ""
echo "✅ Keepbox Git管理の初期化が完了しました"

