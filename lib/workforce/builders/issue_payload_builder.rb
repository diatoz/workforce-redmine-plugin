module Workforce
  module Builders
    class IssuePayloadBuilder
      attr_accessor :issue, :config, :payload

      def initialize(issue, config)
        @issue = issue
        @config = config
        @payload = {}
      end

      def self.build_create_payload(issue, config)
        new(issue, config).build_create_payload
      end

      def self.build_update_payload(issue, config)
        new(issue, config).build_update_payload
      end

      def build_create_payload
        payload[:extRefId]         = issue.id
        payload[:extTktSrc]        = 'REDMINE'
        payload[:groupId]          = config.group_id.presence
        payload[:title]            = issue.subject
        payload[:description]      = issue.description
        payload[:ticketStatusId]   = issue.status_id
        payload[:ticketPriorityId] = issue.priority_id
        payload[:dueDate]          = issue.due_date.try(:iso8601)
        payload[:createdDate]      = issue.created_on.iso8601
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload[:reportedByEmail]  = issue.author_email             if notifiable_issue_field?('author_id')
        payload[:primaryAssignee]  = issue.assignee_email           if notifiable_issue_field?('assigned_to_id')
        payload[:ticketType]       = issue.tracker.name             if notifiable_issue_field?('tracker_id')
        payload[:startDate]        = issue.start_date.try(:iso8601) if notifiable_issue_field?('start_date')
        payload[:doneRatio]        = issue.done_ratio               if notifiable_issue_field?('done_ratio')
        payload[:estimatedHours]   = issue.estimated_hours          if notifiable_issue_field?('estimated_hours')
        payload[:extProjectId]     = issue.project.identifier       if notifiable_issue_field?('project_id')
        payload[:customFields]     = custom_fields_data(true)
        payload[:attachments]      = attachments_data
        payload.compact
      end

      def build_update_payload
        payload[:extRefId]         = issue.id
        payload[:title]            = issue.subject                  if changes_include?('subject')
        payload[:description]      = issue.description              if changes_include?('description')
        payload[:ticketStatusId]   = issue.status_id                if changes_include?('status_id')
        payload[:ticketPriorityId] = issue.priority_id              if changes_include?('priority_id')
        payload[:dueDate]          = issue.due_date.try(:iso8601)   if changes_include?('due_date')
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload[:primaryAssignee]  = issue.assignee_email           if changes_include?('assigned_to_id') && notifiable_issue_field?('assigned_to_id')
        payload[:ticketTypeId]     = issue.tracker.name             if changes_include?('tracker_id') && notifiable_issue_field?('tracker_id')
        payload[:startDate]        = issue.start_date.try(:iso8601) if changes_include?('start_date') && notifiable_issue_field?('start_date')
        payload[:doneRatio]        = issue.done_ratio               if changes_include?('done_ratio') && notifiable_issue_field?('done_ratio')
        payload[:estimatedHours]   = issue.estimated_hours          if changes_include?('estimated_hours') && notifiable_issue_field?('estimated_hours')
        payload[:extProjectId]     = issue.project.identifier       if changes_include?('project_id') && notifiable_issue_field?('project_id')
        payload[:customFields]     = custom_fields_data(false)
        payload[:attachments]      = attachments_data
        payload.compact
      end

      def custom_fields_data(create_payload)
        custom_field_values = create_payload ? issue.custom_values : issue.custom_values.select(&:value_previously_changed?)
        notifiable_values = custom_field_values.select { |custom_value| notifiable_custom_field_id?(custom_value.custom_field_id) }
        return nil if notifiable_values.blank?

        data = []
        attachment_field_ids = issue.attachment_custom_field_ids
        notifiable_values.each do |custom_value|
          data << {
            customValueId: custom_value.id,
            customFieldId: custom_value.custom_field_id,
            customValue: (
              if attachment_field_ids.include?(custom_value.custom_field_id)
                attachment = Attachment.find_by(id: custom_value.value)
                attachment.present? ? { id: attachment.id, name: attachment.filename, contentType: attachment.content_type } : ""
              else
                custom_value.value
              end
            )
          }
        end
        data
      end

      def attachments_data
        return nil unless issue.saved_attachments.present?

        attachments = []
        issue.saved_attachments.each do |attachment|
          attachments << { id: attachment.id, name: attachment.filename, contentType: attachment.content_type }
        end
        attachments
      end

      def changes_include?(key)
        issue.previous_changes.include?(key)
      end

      def notifiable_issue_field?(field)
        config.notifiable_issue_fields.include?(field)
      end

      def notifiable_custom_field_id?(id)
        config.notifiable_custom_field_ids.include?(id)
      end
    end
  end
end
