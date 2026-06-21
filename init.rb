require 'redmine'
require File.expand_path('../lib/redmine_slack_webhook', __FILE__)

Redmine::Plugin.register :redmine_slack_webhook do
  name 'Redmine Slack Webhook'
  author 'Your Name'
  description 'Slack webhook notification for Redmine'
  version '1.0.0'
  url 'https://github.com/yourusername/redmine-slack-webhook'
  author_url 'https://github.com/yourusername'

  requires_redmine :version_or_higher => '6.0.0'

  settings default: {
    'webhook_url' => '',
    'username' => 'Redmine',
    'icon' => ':redmine:'
  }, partial: 'settings/slack_webhook_settings'

  project_module :slack_webhook do
    permission :manage_slack_webhook, { slack_webhook_settings: [:show, :update] }
  end

  menu :project_menu, :slack_webhook_settings, { controller: 'slack_webhook_settings', action: 'show' },
       caption: :label_slack_webhook_settings,
       after: :settings,
       param: :project_id
end

Rails.application.config.after_initialize do
  unless Issue.included_modules.include? RedmineSlackWebhook::IssuePatch
    Issue.send(:include, RedmineSlackWebhook::IssuePatch)
  end
end
