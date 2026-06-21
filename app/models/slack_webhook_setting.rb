class SlackWebhookSetting < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true, uniqueness: true

  def self.setting_for(project)
    return nil if project.blank?

    setting = find_by(project_id: project.id)
    return setting if setting

    setting_for(project.parent)
  end

  def webhook_url_or_default
    webhook_url.presence || Setting.plugin_redmine_slack_webhook['webhook_url']
  end
end
