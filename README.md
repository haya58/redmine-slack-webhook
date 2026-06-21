# Redmine Slack Webhook Plugin

Redmine 6系対応のSlack Webhook通知プラグインです。チケットの作成・更新をSlackに通知します。

## 機能

- チケット作成時のSlack通知
- チケット更新時のSlack通知（ステータス変更、コメント追加など）
- プロジェクトごとの通知設定（ON/OFF、Webhook URL）
- グローバル設定（デフォルトWebhook URL、ユーザー名、アイコン）

## インストール

1. Redmineのpluginsディレクトリにこのプラグインを配置します：

```bash
cd /path/to/redmine/plugins
git clone https://github.com/yourusername/redmine-slack-webhook.git redmine_slack_webhook
```

2. マイグレーションを実行します：

```bash
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

3. Redmineを再起動します。

## 設定

### グローバル設定

管理画面 > プラグイン > Redmine Slack Webhook > 設定

- **Webhook URL**: SlackのIncoming Webhook URL
- **ユーザー名**: Slackに表示されるユーザー名
- **アイコン**: 絵文字（`:redmine:`）または画像URL

### プロジェクトごとの設定

プロジェクト設定 > Slack Webhook

- **通知を有効にする**: チェックで通知を有効化
- **Webhook URL**: プロジェクト固有のWebhook URL（未設定時はグローバル設定を使用）

## 動作要件

- Redmine 6.0以上
- Ruby 3.1以上

## ライセンス

MIT License
