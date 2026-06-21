module RedmineSlackWebhook
  module ProjectsControllerPatch
    def settings
      super
      @tabs << {
        name: 'slack_webhook',
        partial: 'projects/settings/slack_webhook',
        label: :label_slack_webhook_settings
      }
    end
  end
end
