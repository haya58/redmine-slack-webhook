# redmine-slack-webhook
Redmine のチケットの作成・更新情報を Webhook で Slack に通知するプラグインです。
Redmine 6系対応。

## 機能
- チケット作成・更新時の Slack への通知
- プロジェクトごとの通知設定
  - プロジェクトごとの通知の ON/OFF 設定
  - プロジェクトごとの異なる Webhook URL を設定
- Discord への対応
  - Discord で使用する際は、Webhook URL の末尾に `/slack` をつけてください

## インストール
plugins ディレクトリへの設置
```bash
cd /path/to/redmine/plugins
git clone https://github.com/yourusername/redmine-slack-webhook.git redmine_slack_webhook
```
マイグレーション
```bash
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Redmine を再起動します。

## 設定

### グローバル設定
管理画面 > プラグイン > Redmine Slack Webhook > 設定

- **Webhook URL**: Slack の Incoming Webhook URL
- **ユーザー名**: Slack に表示されるユーザー名
- **アイコン**: 絵文字（`:redmine:`）または画像 URL

### プロジェクトごとの設定
プロジェクト設定 > Slack Webhook

- **通知を有効にする**: チェックで通知を有効化
- **Webhook URL**: プロジェクト固有の Webhook URL（未設定時はグローバル設定を使用）

## 動作要件
- Redmine 6.0以上
- Ruby 3.1以上
