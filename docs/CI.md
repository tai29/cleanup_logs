# CI 運用ポリシー

## CI の目的

- コード品質の維持（lint、構文チェック）
- セキュリティチェック（機密情報の漏洩防止）
- 一貫性の確保（フォーマットチェック）

> **注意:** ワークフローファイル（`.github/workflows/*.yml`）は権限の都合で手動追加が必要です。詳細は [GITHUB_ACTIONS_SETUP.md](../GITHUB_ACTIONS_SETUP.md) を参照してください。

## ワークフロー

### 自動実行タイミング

- `push` イベント: main ブランチへのプッシュ時
- `pull_request` イベント: PR 作成・更新時

### 実行されるチェック

1. **ShellCheck (Lint)**

   - シェルスクリプトのベストプラクティス違反を検出
   - 警告は許可（`|| true`）、エラーは失敗

2. **構文チェック**

   - `bash -n` で各スクリプトの構文を検証
   - 構文エラーがある場合は CI 失敗

3. **フォーマットチェック (shfmt)**

   - コードフォーマットの一貫性を確認
   - 差分がある場合は警告

4. **セキュリティスキャン**
   - 機密情報（password, secret, api_key 等）の検出
   - 誤検知を避けるため、特定のパターンは除外

## 失敗時の対応

### CI が失敗した場合

1. **ローカルで再現**

   ```bash
   make lint
   make test
   ```

2. **エラーを修正**

   - ShellCheck の警告/エラーを確認
   - 構文エラーを修正
   - フォーマットを統一: `make fmt`

3. **再コミット**
   ```bash
   git add .
   git commit -m "Fix: CIエラーを修正"
   git push
   ```

### よくある失敗パターン

#### ShellCheck エラー

```bash
# ローカルで確認
shellcheck script.sh

# 自動修正できない場合は手動で修正
```

#### 構文エラー

```bash
# 構文チェック
bash -n script.sh

# エラーメッセージを確認して修正
```

#### フォーマット差分

```bash
# 自動フォーマット
make fmt

# コミット
git add .
git commit -m "Format: shfmtでフォーマットを統一"
```

## 受け入れ基準

PR がマージ可能になる条件:

- ✅ すべての CI チェックがパス
- ✅ レビュー承認（該当する場合）
- ✅ コンフリクトなし

## 注意事項

- CI は警告を許可しているため、警告だけでは失敗しない
- セキュリティスキャンは基本的なパターンマッチングのみ
- より厳密なチェックが必要な場合は、ローカルで `make lint` を実行

## トラブルシューティング

### CI が実行されない

- GitHub Actions が有効になっているか確認
- ワークフローファイルが `.github/workflows/` に存在するか確認
- リポジトリの Settings → Actions で確認

### 権限エラー

- GitHub CLI の認証スコープを確認: `gh auth status`
- 必要に応じて更新: `gh auth refresh -s workflow`

## pre-commit フック（任意）

ローカルでコミット前にチェックを実行する場合、pre-commit フックを設定できます。

### 例: `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.9.0.6
    hooks:
      - id: shellcheck
        args: ["--severity=warning"]

  - repo: https://github.com/scop/pre-commit-shfmt
    rev: v3.7.0-4
    hooks:
      - id: shfmt
        args: ["-w", "-s", "-i", "2"]

  - repo: local
    hooks:
      - id: syntax-check
        name: Shell syntax check
        entry: bash -n
        language: system
        files: \.sh$
```

### セットアップ

```bash
# pre-commit をインストール
pip install pre-commit

# フックをインストール
pre-commit install

# 手動実行
pre-commit run --all-files
```

> **注意:** pre-commit は任意の設定です。必須ではありませんが、ローカルでの品質チェックに有用です。
