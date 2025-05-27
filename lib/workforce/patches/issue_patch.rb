require_dependency 'issue'

module Workforce
  module Patches
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
          return true if saved_attachments.present?
          return true if workforce_config.notifiable_issue_fields.any? { |column| previous_changes.include?(column) }
          return true if custom_values.any? { |field| workforce_config.notifiable_custom_field_ids.include?(field.custom_field_id) && field.value_previously_changed? }

          false
        end

        def attachment_custom_field_ids
          custom_field_values.map { |field| field.custom_field.field_format == 'attachment' ? field.custom_field.id : nil}.compact
        end
      end
    end
  end
end

unless Issue.included_modules.include?(Workforce::Patches::IssuePatch)
  Issue.send(:include, Workforce::Patches::IssuePatch)
end
