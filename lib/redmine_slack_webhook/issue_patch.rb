module RedmineSlackWebhook
  class IssuePatch
    def self.included(base)
      base.class_eval do
        after_create :notify_slack_on_create
        after_save :notify_slack_on_update
      end
    end

    private

    def notify_slack_on_create
      Redmine::Hook.call_hook(:redmine_slack_webhook_issue_created, { issue: self })
      true
    end

    def notify_slack_on_update
      return true if current_journal.nil?
      Redmine::Hook.call_hook(:redmine_slack_webhook_issue_updated, { issue: self, journal: current_journal })
      true
    end
  end
end
