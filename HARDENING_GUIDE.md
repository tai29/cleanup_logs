# 堅牢化ガイド

## 実装済みの堅牢化機能

### 1. 承認ファイルにTTL（15分）

承認ファイルは15分間のみ有効。期限切れなら自動ブロック。

**使用方法**:
```bash
# 承認ファイルを作成（15分間有効）
~/Documents/cleanup_logs/approve.sh

# または手動で
echo $(date +%s) > ~/.approve_maintenance
```

**自動削除**: 15分後に自動削除されます。

### 2. スクリプト改ざん検知（ハッシュ検証）

スクリプトのハッシュ値を検証し、改ざんを検知。

**チェックサムファイル**: `~/Documents/cleanup_logs/.checksums`

**更新方法**:
```bash
cd ~/Documents/cleanup_logs
shasum -a 256 ~/Desktop/cleanup_desktop.sh ~/Downloads/cleanup_downloads.sh | \
  while read hash file; do
    echo "sha256  $hash  $(basename "$file")" >> .checksums
  done
```

### 3. デスクトップ通知

整理完了時に通知を表示。

- Desktop整理完了
- Downloads整理完了
- DRY実行完了
- 承認が必要な場合

### 4. ログの総量制限（200MB超で古い順削除）

`monthly_check.sh`に組み込み済み。

- ログ総量が200MBを超えると古いログを自動削除
- 最大50ファイルまで保持

### 5. 復旧ドリルの自動テスト（月1）

毎月1日 9:15に自動実行（DRY）。

- `restore_last_cleanup.sh --dry-run`を実行
- ログで確認: `~/Documents/cleanup_logs/restore_drill.out`

## 機微データの保護運用

### 証明系の暗号化

- **GPG/Zip**: 年1で再暗号化（旧ファイル削除）
- **Spotlight除外**: `_encrypted.noindex` を維持
- **1Password**: 項目名を用途固定（例：`GPG JobHunt 2025`）＋更新日をメモ

### 更新手順（年1回）

1. 12/1に承認ファイルを作成
   ```bash
   ~/Documents/cleanup_logs/approve.sh
   ```

2. Archive保守を実行
   ```bash
   ~/Documents/cleanup_logs/archive_maintenance.sh
   ```

3. 暗号化ファイルを作り直し
   - `Sensitive-YYYY.zip`/GPG を作成
   - 旧キー/旧Zipを削除

4. ガイドに日付を追記
   - `証明書復号化ガイド.md` に「新パス適用済み」の日付を追記

## 同期・バックアップの詰まり回避

### iCloud対象の場合

`_Archive` と `_Installers` は**iCloud外**へ移動：

```bash
# Desktop ArchiveをiCloud外へ
mv ~/Desktop/_Archive ~/Documents/DesktopArchive

# Downloads ArchiveをiCloud外へ
mv ~/Downloads/_Archive ~/Documents/DownloadsArchive

# Downloads InstallersをiCloud外へ
mv ~/Downloads/_Installers ~/Documents/DownloadsInstallers
```

### Time Machineの除外

```bash
# InstallersをTime Machineから除外
tmutil addexclusion ~/Downloads/_Installers

# 確認
tmutil isexcluded ~/Downloads/_Installers
```

## ラストワンコマンド（定常の健全性チェック）

```bash
~/Documents/cleanup_logs/health_check.sh && tail -50 ~/Documents/cleanup_logs/*.out 2>/dev/null
```

## KeepboxのGit管理（オプション）

テンプレや職務経歴の差分履歴を資産化：

```bash
# 初期化
~/Documents/cleanup_logs/setup_keepbox_git_simple.sh

# 非公開リモートを追加
cd ~/Documents/Keepbox
git remote add origin <your-private-repo-url>
git push -u origin main
```

## このセットで実現できること

✅ **消えない**: 承認ファイル必須、TTL、改ざん検知  
✅ **戻せる**: 復旧ドリル、移動ログ、巻き戻しスクリプト  
✅ **走り続ける**: 自動実行、ログ管理、通知

**長期で安定した運用が可能です。**

