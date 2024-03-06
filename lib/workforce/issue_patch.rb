module Workforce
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_detail, class_name: "WorkforceConfiguration", through: :project

      after_commit :notify_workforce

      def assignee_email
        assigned_to.try(:mail)
      end

      def author_email
        author.mail
      end

      def notify_workforce
        Workforce::Message.new(self).notify
      rescue => e
        Rails.logger.info "Workfoce Notification Failed"
        Rails.logger.info e.message
        Rails.logger.info e.backtrace
      end
    end
  end
end
