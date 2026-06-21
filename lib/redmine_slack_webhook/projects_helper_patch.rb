module RedmineSlackWebhook
  module ProjectsHelperPatch
    def project_settings_tabs
      tabs = super
      tabs << {
        name: 'slack_webhook',
        action: :edit_project,
        partial: 'projects/settings/slack_webhook',
        label: :label_slack_webhook_settings
      }
      tabs
    end
  end
end
