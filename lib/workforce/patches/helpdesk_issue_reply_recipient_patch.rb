module Workforce
  module Patches
    module HelpdeskIssueReplyRecipientPatch
      extend ActiveSupport::Concern

      included do
        def receive_with_workforce(issue_id)
          journal = receive_without_workforce(issue_id)
          return journal unless journal.is_a?(Journal)

          issue = journal.issue
          return journal unless issue

          # Workforce must be enabled OR helpdesk ticket
          return journal unless issue.workforce_notifiable? || issue.is_ticket?

          # Only customer incoming emails
          return journal unless journal.journal_message.present?
          return journal unless journal.journal_message.is_incoming
          
          NotifyHelpdeskCustomerReplyJob.set(wait: 1.second).perform_later(issue_id, journal.id)

          journal
        end

        class_eval do
          alias_method :receive_without_workforce, :receive
          alias_method :receive, :receive_with_workforce
        end
      end
    end
  end
end

unless HelpdeskMailRecipient::IssueReplyRecipient.included_modules.include?(Workforce::Patches::HelpdeskIssueReplyRecipientPatch)
  HelpdeskMailRecipient::IssueReplyRecipient.send(:include,Workforce::Patches::HelpdeskIssueReplyRecipientPatch)
end
