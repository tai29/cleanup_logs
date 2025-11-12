# 安全装置と自動化ガイド

## 安全装置（承認ファイル必須）

すべての削除・圧縮系スクリプトは**承認ファイル必須**で誤爆ゼロ。

### 実行方法

```bash
# 実行したい日だけ承認ファイルを作成
touch ~/.approve_maintenance

# スクリプト実行
~/Documents/cleanup_logs/archive_maintenance.sh

# 実行後は削除（安全のため）
rm ~/.approve_maintenance
```

### 対象スクリプト

- `archive_maintenance.sh` - Archive保守（圧縮・削除）

## 自動実行スケジュール

### 毎週月曜 9:00
- **Desktop整理**（DRY実行）
- `com.user.desktop.cleanup`

### 毎週月曜 9:30
- **Downloads整理**（DRY実行）
- `com.user.downloads.cleanup`

### 毎月1日 9:10
- **月次チェック**（読むだけ系）
- `com.user.monthly.check`
- レポート確認・ログ回転

### 四半期（1/4/7/10月の1日 9:20）
- **Archive保守**（承認ファイルが無ければブロック）
- `com.user.quarterly.archive`
- 6か月超を圧縮、12か月超を削除

## ログ回転（肥大防止）

`monthly_check.sh` に組み込み済み：
- 5MB超のログファイルを自動削除

## Keepbox の Git 管理

### 初期化ワンショット

```bash
~/Documents/cleanup_logs/setup_keepbox_git_simple.sh
```

### 手動初期化

```bash
mkdir -p ~/Documents/Keepbox && cd $_
git init
echo -e "*.zip\n*.gpg\nSensitive-*.zip\n" >> .gitignore
git add -A && git commit -m "init keepbox"

# 非公開リモートを後で追加
git remote add origin <ssh-url>
git push -u origin main
```

## 年1の暗号化更新（手順固定化）

### 12/1 に実行

1. 承認ファイルを作成
   ```bash
   touch ~/.approve_maintenance
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

5. 承認ファイルを削除
   ```bash
   rm ~/.approve_maintenance
   ```

## ラストチェック（30秒）

```bash
~/Documents/cleanup_logs/final_check.sh
```

または手動で：

```bash
echo "== SCHEDULE =="; launchctl list | egrep 'desktop.cleanup|downloads.cleanup|monthly.check|quarterly.archive' || true
echo "== DISK =="; df -h /
echo "== LOG TAIL =="; tail -50 ~/Documents/cleanup_logs/*.out 2>/dev/null
```

## このセットで実現できること

✅ **手動承認なしに消えない** - 承認ファイル必須で誤爆ゼロ  
✅ **回り続ける** - launchdで自動実行  
✅ **軽く保てる** - ログ回転・Archive圧縮・削除

**「誤削除しない・戻せる・勝手に整う」が継続します。**

