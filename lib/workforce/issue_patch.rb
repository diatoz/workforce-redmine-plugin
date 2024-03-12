module Workforce
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_config, class_name: "WorkforceConfiguration", through: :project

      after_commit :notify_workforce, unless: :workforce_user?

      def assignee_email
        assigned_to.try(:mail)
      end

      def author_email
        author.mail
      end

      def notify_workforce
        Workforce::Message.new(self).notify
      rescue => e
        Workforce.logger.error "Worforce Notification push failed. Reasone: #{e.message}"
      end

      def workforce_user?
        User.current.mail == workforce_config.email
      end
    end
  end
end
