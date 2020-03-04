require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  config.ignore_if do
    !Rails.env.production?
  end
  config.add_notifier :slack, {
      webhook_url: Rails.application.credentials.dig(:slack, :webhook_url),
      channel: Settings.slack.exception_notification_channel
  }
end
