module Workforce
  module Patches
    module HelpdeskIssueRecipientPatch
      extend ActiveSupport::Concern

      included do
        def receive_with_workforce
          issue = receive_without_workforce
          issue.notify_helpdesk_ticket_to_workforce if issue.is_a?(Issue)
        end

        class_eval do
          alias_method :receive_without_workforce, :receive
          alias_method :receive, :receive_with_workforce
        end
      end
    end
  end
end

unless HelpdeskMailRecipient::IssueRecipient.included_modules.include?(Workforce::Patches::HelpdeskIssueRecipientPatch)
  HelpdeskMailRecipient::IssueRecipient.send(:include, Workforce::Patches::HelpdeskIssueRecipientPatch)
end
