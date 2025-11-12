# コントリビューションガイド

このプロジェクトへの貢献を歓迎します！

## 開発環境のセットアップ

1. リポジトリをフォーク
2. ローカルにクローン
3. ブランチを作成: `git checkout -b feature/your-feature-name`
4. 変更をコミット: `git commit -m "Add some feature"`
5. ブランチにプッシュ: `git push origin feature/your-feature-name`
6. プルリクエストを作成

## コーディング規約

### シェルスクリプト

- `#!/bin/bash` で始める
- `set -euo pipefail` を使用
- 変数は引用符で囲む
- 関数名は小文字とアンダースコア
- エラーメッセージは標準エラー出力に

詳細は `.cursorrules/` ディレクトリ内の各ファイルを参照してください。

### コミットメッセージ

- 明確で簡潔なメッセージ
- 日本語または英語
- 変更の種類を明示（例: "Add", "Fix", "Update", "Remove"）

## テスト

変更をコミットする前に：

```bash
# Makefileを使用（推奨）
make lint    # shellcheck実行
make test    # 構文チェック

# または手動で
bash -n your_script.sh
shellcheck your_script.sh
```

> **注意:** Makefileの使用には `shellcheck`, `shfmt`, `jq`, `curl` が必要です。インストール方法は [README.md](../README.md) を参照してください。

> **注意:** CI/CDワークフローファイル（`.github/workflows/*.yml`）は権限の都合で手動追加が必要です。詳細は [GITHUB_ACTIONS_SETUP.md](../GITHUB_ACTIONS_SETUP.md) を参照してください。

## プルリクエスト

- 変更内容を明確に説明
- 関連するIssueがあれば参照
- テスト結果を含める
- スクリーンショットや例があると良い

## 質問や提案

Issueを作成して質問や提案をしてください。

