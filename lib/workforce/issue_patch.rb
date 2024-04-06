module Workforce
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_config, class_name: "WorkforceConfiguration", through: :project

      def assignee_email
        assigned_to.try(:mail)
      end

      def author_email
        author.mail
      end

      def can_notify_workforce?
        workforce_config.present? && workforce_config.is_enabled?
      end
    end
  end
end
