class NotifyHelpdeskCustomerReplyJob < ApplicationJob
  queue_as :default

  def perform(issue_id, journal_id)
    issue   = Issue.find_by(id: issue_id)
    journal = Journal.find_by(id: journal_id)

    return unless issue && journal

    config = issue.workforce_config
    return unless config

    payload = Workforce::Builders::CommentsDataBuilder.build_create_payload(journal)
    Workforce::Client.create_comment(config, payload)
  rescue => e
    Workforce.logger.error "Customer email reply notify failed for issue #{issue_id}, journal #{journal_id}: #{e.message}"
    Workforce.logger.error e.backtrace
  end
end
