# Ошибки отправляются в Bugsink (Sentry-совместимый коллектор), если задан DSN
if ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.send_default_pii = false
  end
end
