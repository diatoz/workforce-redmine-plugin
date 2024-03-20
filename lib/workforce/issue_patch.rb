module Workforce
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_config, class_name: "WorkforceConfiguration", through: :project

      after_commit :notify_workforce, unless: :workforce_user?, if: :has_workforce_config?

      def assignee_email
        assigned_to.try(:mail)
      end

      def author_email
        author.mail
      end

      def notify_workforce
        Workforce::Message.new(self).notify
      rescue => e
        Workforce.logger.error "Exception occured during notifying issue #{self.id}, Reason: #{e.message}"
        Workforce.logger.error e.backtrace
        WorkforceAudit.create(source_id: self.id, source_type: self.class, action: 'notification', error_message: e.message, error_backtrace: Rails.backtrace_cleaner.clean(e.backtrace)) rescue nil
      end

      def workforce_user?
        User.current.mail == workforce_config.email
      end

      def has_workforce_config?
        workforce_config.present? && workforce_config.api_key.present?
      end
    end
  end
end
