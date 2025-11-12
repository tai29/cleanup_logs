# 最終運用ガイド

## 動作確認（30秒）

### 通知とTTLの動作確認

```bash
# 通知テスト
osascript -e 'display notification "通知テスト" with title "Cleanup"'

# 承認TTLテスト
~/Documents/cleanup_logs/approve.sh      # 承認ファイル作成
cat ~/.approve_maintenance              # タイムスタンプ確認

# 15分後: archive_maintenance.sh を実行 → [BLOCK] approval expired が出ればOK
```

**一括確認**:
```bash
~/Documents/cleanup_logs/verify_system.sh
```

## チェックサムの扱い（改変時の正しい手順）

スクリプトを編集した日だけ、**意図的に**ベースラインを更新。

### 自動更新

```bash
~/Documents/cleanup_logs/update_checksums.sh
```

### 手動更新

```bash
cd ~/Documents/cleanup_logs
cp .checksums .checksums.bak  # バックアップ

# 新しいハッシュ値を計算
shasum -a256 ~/Desktop/cleanup_desktop.sh | awk '{print "sha256  "$1"  cleanup_desktop.sh"}'
shasum -a256 ~/Downloads/cleanup_downloads.sh | awk '{print "sha256  "$1"  cleanup_downloads.sh"}'

# 上の2行の出力で .checksums を手動更新 → 保存
```

**誤って上書きした場合**: `.checksums.bak` を戻せばOK。

## "勝手に消えない"最終確認

```bash
~/Documents/cleanup_logs/verify_safety.sh
```

または手動で:

```bash
# 削除禁止フラグが効いているか
rm -f ~/.approve_maintenance
~/Documents/cleanup_logs/archive_maintenance.sh 2>&1 | grep -E 'BLOCK|approval'
```

`BLOCK` と `approval` の両方が出ていれば、**承認なしでは破壊的処理が走らない**ことが確認できる。

## 権限の締め（承認ファイルののぞき見防止）

```bash
~/Documents/cleanup_logs/secure_permissions.sh
```

または手動で:

```bash
chmod 600 ~/.approve_maintenance 2>/dev/null || true
```

**より堅牢にする場合**（.zshrcに追加）:
```bash
umask 077  # デフォルト権限を厳しく
```

## 非常時の標準手順（3行だけ覚える）

### 1. 直近ログを見る

```bash
tail -100 ~/Documents/cleanup_logs/*.out
```

### 2. 巻き戻す

```bash
~/Desktop/restore_last_cleanup.sh
```

### 3. それでも戻らない

Time Machine → 該当フォルダ復元（/Documents または /Downloads）

**一括実行**:
```bash
~/Documents/cleanup_logs/emergency_recovery.sh
```

## 定常の見るべき場所（週1で10秒）

```bash
~/Documents/cleanup_logs/quick_status.sh
```

または手動で:

```bash
tail -40 ~/Desktop/Cleanup-Report.out 2>/dev/null
tail -40 ~/Documents/cleanup_logs/downloads.out 2>/dev/null
launchctl list | egrep 'desktop.cleanup|downloads.cleanup|monthly.check|restore_drill|quarterly.archive' || true
```

## 運用フロー

### 毎週
- 自動実行（DRY）→ レポート確認（10秒）

### 毎月
- 月次チェック自動実行
- 復旧ドリル自動実行（DRY）

### 四半期
- Archive保守（承認ファイル作成 → 実行）

### 年1回
- 暗号化パス更新
- チェックサム更新（スクリプト改変時のみ）

## 完成した機能

✅ **承認なしに消えない** - 承認ファイル必須、TTL付き  
✅ **改ざん検知** - ハッシュ検証  
✅ **通知あり** - 整理完了時に通知  
✅ **自動化はDRY中心** - 安全確認してから本番

**以後は週1でレポートを一瞥、四半期のアーカイブ保守だけ承認して回せばOK。**

