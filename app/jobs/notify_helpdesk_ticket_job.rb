class NotifyHelpdeskTicketJob < ApplicationJob

  def perform(issue)
    config = issue.workforce_config
    payload = Workforce::Builders::IssuesDataBuilder.build_create_payload(issue, config)
    Workforce::Client.create_ticket(config, payload)
  rescue => e
    Workforce.logger.error "Notification failed for issue id #{issue.id}, reason: #{e.message}"
    Workforce.logger.error e.backtrace
  end
end
