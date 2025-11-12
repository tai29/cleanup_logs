# 保守ガイド（実務向け）

## 月1チェック（60秒）

```bash
~/Documents/cleanup_logs/monthly_check.sh
```

- 直近DRYレポートを確認
- 退避量の推移を確認（容量の暴れ検知）

## 保持ポリシー（6か月で圧縮→12か月で削除）

```bash
~/Documents/cleanup_logs/archive_maintenance.sh
```

- 6か月超のArchiveを圧縮
- 12か月超の圧縮ファイルを削除

**実行タイミング**: 四半期ごと（推奨）

## 詰まりの早期検知

```bash
~/Documents/cleanup_logs/disk_check.sh
```

- 空き容量10GB未満なら警告
- iCloud対象なら _Archive を iCloud外へ退避を推奨

## Git系の追加安全網

各リポジトリで1回実行：

```bash
cd /path/to/project
~/Documents/cleanup_logs/setup_git_precommit.sh
```

- 50MB以上のファイルのコミットをブロック
- 大容量誤登録を防止

## 暗号化まわりの運用メモ

### パス更新（年1回）

1. `Sensitive-YYYY.zip`/GPGの**再暗号化**
2. 古いZip/GPGは破棄

### Spotlight除外

`_encrypted.noindex` を維持（見えない＝漏れにくい）

## 1コマンド健康診断

```bash
~/Documents/cleanup_logs/health_check.sh
```

困ったら叩く：
- スケジュール確認
- ディスク容量確認
- エラーログ確認
- Archive容量確認

## KeepboxのGit管理（オプション）

テンプレや職務経歴の差分履歴を資産化：

```bash
# 初期化（リモートURLはオプション）
~/Documents/cleanup_logs/setup_keepbox_git.sh [remote-url]

# または手動で
cd ~/Documents/Keepbox
git init
git add .
git commit -m "Initial commit"
git remote add origin <your-private-repo-url>
git push -u origin main
```

## 運用フロー

1. **毎週**: 自動実行（DRY）→ レポート確認
2. **毎月**: `monthly_check.sh` で状態確認
3. **四半期**: `archive_maintenance.sh` で圧縮・削除
4. **年1回**: 暗号化パス更新

この状態なら**「誤削除しない・戻せる・勝手に整う」**が継続します。

