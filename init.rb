require 'redmine'
require File.expand_path('../lib/redmine_slack_webhook', __FILE__)

Redmine::Plugin.register :redmine_slack_webhook do
  name 'Redmine Slack Webhook'
  author 'haya58'
  description 'Slack webhook notification for Redmine'
  version '1.0.0'
  url 'https://github.com/haya58/redmine-slack-webhook'
  author_url 'https://github.com/haya58'

  requires_redmine :version_or_higher => '6.0.0'

  settings default: {
    'webhook_url' => '',
    'username' => 'Redmine',
    'icon' => ':redmine:'
  }, partial: 'settings/slack_webhook_settings'
end

Rails.application.config.after_initialize do
  unless Issue.included_modules.include? RedmineSlackWebhook::IssuePatch
    Issue.send(:include, RedmineSlackWebhook::IssuePatch)
  end

  unless ProjectsHelper.ancestors.include? RedmineSlackWebhook::ProjectsHelperPatch
    ProjectsHelper.prepend(RedmineSlackWebhook::ProjectsHelperPatch)
  end
end
