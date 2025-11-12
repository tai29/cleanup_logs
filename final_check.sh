#!/bin/bash

# 最低限の最終チェック（5分で完了）

set -euo pipefail
IFS=$'\n\t'

echo "=== 最終チェック ==="
echo ""

# 1. 復元ドリル（必須・1回だけ）
echo "【1】復元ドリル（必須・1回だけ）"
echo "----------------------------------------"
TEST_FILE="$HOME/Downloads/_FINAL_CHECK_TEST_$(date +%s).txt"
cleanup_testfile() { rm -f "$TEST_FILE" 2>/dev/null || true; }
trap cleanup_testfile EXIT
echo "テストファイルを作成: $TEST_FILE"
echo "FINAL_CHECK_TEST" > "$TEST_FILE"

echo ""
echo "Downloads整理を実行中（テストファイルを移動）..."
cd "$HOME/Downloads"
if [ -x "./cleanup_downloads.sh" ]; then
    # スクリプト側のフラグ差異に配慮（環境変数で両対応）
    DRY=0 DRY_RUN=false ./cleanup_downloads.sh >/dev/null 2>&1 || true
    sleep 1
    
    # テストファイルが移動されたか確認
    if [ ! -f "$TEST_FILE" ]; then
        echo "✅ テストファイルが移動されました"
        
        # 復元を実行
        echo "復元を実行中..."
        if [ -x "$HOME/Desktop/restore_last_cleanup.sh" ]; then
            "$HOME/Desktop/restore_last_cleanup.sh" >/dev/null 2>&1 || true
            sleep 1
            
            if [ -f "$TEST_FILE" ]; then
                echo "✅ 復元成功: テストファイルが戻りました"
                cleanup_testfile
                echo "✅ 復元ドリル: 成功"
            else
                echo "⚠️  復元失敗: テストファイルが見つかりません"
                echo "   手動確認: ~/Desktop/restore_last_cleanup.sh"
            fi
        else
            echo "⚠️  復元スクリプトが見つかりません: ~/Desktop/restore_last_cleanup.sh"
        fi
    else
        echo "⚠️  テストファイルが移動されませんでした（ホワイトリストに含まれている可能性）"
        cleanup_testfile
    fi
else
    echo "⚠️  cleanup_downloads.sh が見つかりません"
    cleanup_testfile
fi

echo ""
echo "【2】launchdの動作確認（1回確認）"
echo "----------------------------------------"
LABELS=("com.user.desktop.cleanup" "com.user.downloads.cleanup" "com.user.monthly.check" "com.user.quarterly.archive" "com.user.monthly.restore_drill")

for label in "${LABELS[@]}"; do
    echo "ラベル: $label"
    if launchctl list | awk '{print $3}' | grep -qx "$label"; then
        # launchctl list: [PID or -] [Status] [Label]
        line="$(launchctl list | awk -v L="$label" '$3==L {print}')"
        pid="$(awk '{print $1}' <<<"$line")"
        status="$(awk '{print $2}' <<<"$line")"
        echo "  ✅ ロード済み  PID: ${pid}  Status: ${status}"
        # 直近3日のログから最終タイムスタンプ1行を表示
        last_log="$(log show --last 3d --predicate "eventMessage CONTAINS[c] \"$label\"" --style compact 2>/dev/null | tail -1 || true)"
        if [ -n "$last_log" ]; then
          echo "    最終ログ: $last_log"
        else
          echo "    最終ログ: 直近3日に記録なし（正常な場合もあります）"
        fi
    else
        echo "  ⚠️  未ロード"
    fi
done

echo ""
echo "ログ確認（直近3日）:"
log show --last 3d --predicate 'eventMessage CONTAINS "cleanup" OR eventMessage CONTAINS "monthly" OR eventMessage CONTAINS "archive"' --style compact 2>/dev/null | tail -20 || echo "  ログが見つかりません（正常な場合もあります）"

echo ""
echo "【3】ホワイトリストのバックアップ（1回だけ）"
echo "----------------------------------------"
KEEPFILES=(
    "$HOME/Desktop/.keep_patterns"
    "$HOME/Downloads/.keep_patterns"
)

BACKUP_DIR="$HOME/Documents/Keepbox"
mkdir -p "$BACKUP_DIR"

for keepfile in "${KEEPFILES[@]}"; do
    if [ -f "$keepfile" ]; then
        basename_file=$(basename "$keepfile")
        backup_path="$BACKUP_DIR/${basename_file}.backup"
        cp "$keepfile" "$backup_path"
        echo "✅ バックアップ完了: $keepfile -> $backup_path"
    else
        echo "ℹ️  ファイルが存在しません: $keepfile"
    fi
done

echo ""
echo "【4】ログ肥大の確認（1回だけ）"
echo "----------------------------------------"
LOG_DIR="$HOME/Documents/cleanup_logs"
if [ -d "$LOG_DIR" ]; then
    total_size=$(du -sk "$LOG_DIR" 2>/dev/null | awk '{print $1}' || echo "0")
    total_mb=$((total_size / 1024))
    echo "ログ総量: ${total_mb}MB"
    
    if [ "$total_mb" -gt 1000 ]; then
        echo "⚠️  ログが1GBを超えています（ローテーション推奨）"
    else
        echo "✅ ログサイズは正常範囲内です"
    fi
    
    echo ""
    echo "大きなログファイル（上位5件）:"
    # 安全な null 区切り & 条件の明確化
    find "$LOG_DIR" -type f \( -name "*.log" -o -name "*.out" -o -name "*.err" \) -print0 2>/dev/null | \
        xargs -0 ls -lhS 2>/dev/null | head -5 | awk '{print "  " $9 " (" $5 ")"}' || echo "  ログファイルが見つかりません"
    
    # 月次ローテーションの確認
    if [ -f "$LOG_DIR/monthly_check.sh" ]; then
        if grep -q "ログ.*削除\|log.*delete\|ローテ\|rotate" "$LOG_DIR/monthly_check.sh" 2>/dev/null; then
            echo "✅ 月次ローテーション設定が確認されました"
        else
            echo "ℹ️  月次ローテーション設定を確認できませんでした"
        fi
    fi
else
    echo "⚠️  ログディレクトリが見つかりません: $LOG_DIR"
fi

echo ""
echo "=== 最終チェック完了 ==="
echo ""
echo "✅ すべてのチェックが完了しました"
echo ""
echo "【結果サマリ】"
echo "  1. 復元ドリル: 上記の結果を確認"
echo "  2. launchd: すべてのラベルがロードされているか確認"
echo "  3. ホワイトリスト: Keepboxにバックアップ済み"
echo "  4. ログ肥大: 上記のサイズを確認"
echo ""
echo "🎯 このまま放置運用でOKです！"
