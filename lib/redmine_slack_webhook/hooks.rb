module RedmineSlackWebhook
  class Hooks < Redmine::Hook::Listener
    def redmine_slack_webhook_issue_created(context = {})
      issue = context[:issue]
      return if issue.is_private?

      notifier = Notifier.new(issue.project)
      notifier.notify_issue_created(issue)
    end

    def redmine_slack_webhook_issue_updated(context = {})
      issue = context[:issue]
      journal = context[:journal]
      return if issue.is_private?
      return if journal.private_notes?

      notifier = Notifier.new(issue.project)
      notifier.notify_issue_updated(issue, journal)
    end
  end
end
