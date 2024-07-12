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

      def workforce_notifiable?
        workforce_config.present? && workforce_config.is_enabled?
      end

      def has_workforce_notifiable_changes?
        return true if workforce_config.notifiable_issue_fields.any? { |column| previous_changes.include?(column) }
        return true if custom_values.any? { |field| field.value_previously_changed? }
        return true if saved_attachments.present?

        false
      end
    end
  end
end
