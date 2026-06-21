require 'net/http'
require 'uri'
require 'json'

module RedmineSlackWebhook
  class Notifier
    def initialize(project)
      @project = project
      @setting = SlackWebhookSetting.setting_for(project)
    end

    def notify_issue_created(issue)
      return unless enabled?

      payload = build_issue_payload(issue, :created)
      send_payload(payload)
    end

    def notify_issue_updated(issue, journal)
      return unless enabled?

      payload = build_update_payload(issue, journal)
      send_payload(payload)
    end

    private

    def enabled?
      return false if @setting && !@setting.enabled?
      webhook_url.present?
    end

    def webhook_url
      @setting&.webhook_url_or_default || Setting.plugin_redmine_slack_webhook['webhook_url']
    end

    def username
      Setting.plugin_redmine_slack_webhook['username'] || 'Redmine'
    end

    def icon
      Setting.plugin_redmine_slack_webhook['icon'] || ':redmine:'
    end

    def build_issue_payload(issue, type)
      text = I18n.t("slack_notification_issue_#{type}",
                    user: issue.author.to_s,
                    url: issue_url(issue),
                    subject: issue.subject)

      fields = [
        { title: I18n.t(:slack_notification_field_status), value: issue.status.to_s, short: true },
        { title: I18n.t(:slack_notification_field_priority), value: issue.priority.to_s, short: true },
        { title: I18n.t(:slack_notification_field_assigned_to), value: issue.assigned_to.to_s, short: true }
      ]

      if issue.description.present?
        fields << { title: I18n.t(:slack_notification_field_description), value: truncate(issue.description), short: false }
      end

      build_payload(text, fields)
    end

    def build_update_payload(issue, journal)
      text = I18n.t(:slack_notification_issue_updated,
                    user: journal.user.to_s,
                    url: issue_url(issue),
                    subject: issue.subject)

      fields = journal.details.map { |d| detail_to_field(d) }

      if journal.notes.present?
        fields << { title: I18n.t(:slack_notification_field_description), value: truncate(journal.notes), short: false }
      end

      build_payload(text, fields)
    end

    def build_payload(text, fields)
      {
        username: username,
        icon: icon_param,
        text: text,
        attachments: [{ fields: fields }]
      }
    end

    def icon_param
      icon_str = icon
      if icon_str.start_with?(':')
        { icon_emoji: icon_str }
      else
        { icon_url: icon_str }
      end
    end

    def detail_to_field(detail)
      title = field_title(detail)
      value = field_value(detail)
      short = !%w[subject description].include?(detail.prop_key)

      { title: title, value: value, short: short }
    end

    def field_title(detail)
      case detail.property
      when 'cf'
        detail.custom_field&.name || detail.prop_key
      when 'attachment'
        I18n.t(:label_attachment)
      else
        key = detail.prop_key.to_s.sub('_id', '')
        I18n.t("field_#{key}", default: key.humanize)
      end
    end

    def field_value(detail)
      case detail.property
      when 'cf'
        format_custom_field_value(detail)
      when 'attachment'
        detail.value.to_s
      else
        case detail.prop_key
        when 'status_id'
          IssueStatus.find_by(id: detail.value)&.name || detail.value
        when 'priority_id'
          IssuePriority.find_by(id: detail.value)&.name || detail.value
        when 'assigned_to_id'
          User.find_by(id: detail.value)&.name || detail.value
        when 'tracker_id'
          Tracker.find_by(id: detail.value)&.name || detail.value
        when 'parent_id'
          issue = Issue.find_by(id: detail.value)
          issue ? "##{issue.id}" : detail.value
        else
          detail.value.to_s
        end
      end
    end

    def format_custom_field_value(detail)
      detail.value.to_s
    end

    def issue_url(issue)
      host = Setting.host_name
      protocol = Setting.protocol

      if host.include?(':')
        "#{protocol}://#{host}/issues/#{issue.id}"
      else
        "#{protocol}://#{host}/issues/#{issue.id}"
      end
    end

    def truncate(text, length = 200)
      return '' if text.blank?
      text.length > length ? "#{text[0...length]}..." : text
    end

    def send_payload(payload)
      Thread.new do
        begin
          uri = URI.parse(webhook_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = (uri.scheme == 'https')
          http.open_timeout = 5
          http.read_timeout = 5

          request = Net::HTTP::Post.new(uri.request_uri)
          request['Content-Type'] = 'application/json'
          request.body = payload.to_json

          http.request(request)
        rescue => e
          Rails.logger.error("[RedmineSlackWebhook] Failed to send notification: #{e.message}")
        end
      end
    end
  end
end
