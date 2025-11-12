# GitHub Actions セットアップガイド

## ワークフローファイルの追加

GitHub CLIの認証スコープの制限により、ワークフローファイルを直接プッシュできない場合があります。

### 方法1: GitHub CLIの認証スコープを更新（推奨）

```bash
# GitHub CLIで再認証（workflowスコープを含む）
gh auth refresh -s workflow

# その後、ワークフローファイルをプッシュ
git add .github/workflows/
git commit -m "Add GitHub Actions workflows"
git push
```

### 方法2: GitHub Web UIから追加

1. GitHubリポジトリページにアクセス: https://github.com/tai29/cleanup_logs
2. 「Add file」→「Create new file」をクリック
3. ファイル名を入力: `.github/workflows/ci.yml`
4. 以下の内容をコピー＆ペースト:

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    name: Shell Script Linting
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup ShellCheck
      run: |
        sudo apt-get update
        sudo apt-get install -y shellcheck
    
    - name: Run ShellCheck
      run: |
        find . -name "*.sh" -type f -exec shellcheck {} \; || true
        echo "ShellCheck completed (warnings are allowed)"

  test:
    name: Script Syntax Check
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Check script syntax
      run: |
        for script in *.sh; do
          if [ -f "$script" ]; then
            echo "Checking $script..."
            bash -n "$script" || exit 1
          fi
        done

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Check for secrets
      run: |
        # 機密情報がコミットされていないかチェック
        if grep -r "password\|secret\|api_key\|token" --include="*.sh" --include="*.md" . | grep -v "CURSOR_API_KEY\|環境変数\|example\|TODO" | grep -v "^#"; then
          echo "⚠️  Potential secrets found. Please review."
        else
          echo "✅ No obvious secrets found"
        fi
```

5. 「Commit new file」をクリック
6. 同様に `.github/workflows/cursor-agent.yml` も追加

### 方法3: ローカルファイルを確認して手動で追加

ワークフローファイルは既にローカルに作成されています：

- `.github/workflows/ci.yml`
- `.github/workflows/cursor-agent.yml`

これらの内容をGitHub Web UIから手動で追加してください。

## Cursor Agentワークフローの使用

`cursor-agent.yml` ワークフローを使用するには：

1. リポジトリのSettings → Secrets and variables → Actions
2. 「New repository secret」をクリック
3. Name: `CURSOR_API_KEY`
4. Secret: あなたのCursor APIキー
5. 「Add secret」をクリック

その後、GitHub Actionsのページから手動でワークフローを実行できます。

