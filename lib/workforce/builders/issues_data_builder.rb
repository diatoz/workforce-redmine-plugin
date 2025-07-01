module Workforce
  module Builders
    class IssuesDataBuilder
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

      def self.serialize(issue)
        new(issue, issue.workforce_config).serialize
      end

      def build_create_payload
        payload[:extRefId]         = issue.id
        payload[:extTktSrc]        = 'REDMINE'
        payload[:groupId]          = config.group_id.presence
        payload[:title]            = issue.subject
        payload[:description]      = issue.description
        payload[:ticketStatusId]   = issue.status_id
        payload[:ticketPriorityId] = issue.priority_id
        payload[:assigneeId]       = issue.assigned_to_id
        payload[:dueDate]          = issue.due_date.try(:iso8601)
        payload[:createdDate]      = issue.created_on.iso8601
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload[:customFields]     = custom_fields_data(true)
        payload[:attachments]      = attachments_data
        payload.compact
      end

      def build_update_payload
        payload[:extRefId]         = issue.id
        payload[:title]            = issue.subject                  if field_changed?('subject')
        payload[:description]      = issue.description              if field_changed?('description')
        payload[:ticketStatusId]   = issue.status_id                if field_changed?('status_id')
        payload[:ticketPriorityId] = issue.priority_id              if field_changed?('priority_id')
        payload[:dueDate]          = issue.due_date.try(:iso8601)   if field_changed?('due_date')
        payload[:assigneeId]       = issue.assigned_to_id           if field_changed?('assigned_to_id')  
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload[:customFields]     = custom_fields_data(false)
        payload[:attachments]      = saved_attachments_data
        payload.compact
      end

      def serialize
        payload[:extRefId]         = issue.id
        payload[:extTktSrc]        = 'REDMINE'
        payload[:groupId]          = config.group_id.presence
        payload[:title]            = issue.subject
        payload[:description]      = issue.description
        payload[:ticketStatusId]   = issue.status_id
        payload[:assigneeId]       = issue.assigned_to_id
        payload[:ticketPriorityId] = issue.priority_id
        payload[:dueDate]          = issue.due_date.try(:iso8601)
        payload[:createdDate]      = issue.created_on.iso8601
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload[:customFields]     = custom_fields_data(true)
        payload[:attachments]      = attachments_data
        payload.compact
      end

      def custom_fields_data(create_payload)
        issue_attributes = ISSUE_SUPPORTED_ATTRIBUTES.select { |attribute| notifiable_issue_field?(attribute) }
        notifiable_issue_attributes = create_payload ? issue_attributes : issue_attributes.select { |attribute| field_changed?(attribute) }
        data = notifiable_issue_attributes.map do |attribute|
          {
            name: Issue.human_attribute_name(attribute, locale: :en),
            value: issue_attribute_value(attribute),
            fieldFormat: ISSUE_SUPPORTED_ATTRIBUTES_FORMAT_MAPPING[attribute]
          }
        end
        if create_payload || field_changed?('project_id')
          ancestors = issue.project.ancestors.pluck(:name) << issue_attribute_value("project_id")
          data << {
            name: "Project Path",
            value: ancestors.join(' >> ').presence,
            fieldFormat: "TEXT"
          }
        end
        custom_values = issue.custom_values.select { |custom_value| notifiable_custom_field?(custom_value.custom_field) }
        notifiable_custom_values = (create_payload ? custom_values : custom_values.select(&:value_previously_changed?)).uniq(&:custom_field_id)
        notifiable_custom_values.each do |custom_value|
          data << {
            id: custom_value.custom_field_id,
            name: custom_value.custom_field.name,
            value: custom_field_value(custom_value.custom_field),
            fieldFormat: custom_value.custom_field.workforce_field_format
          }
        end
        data.compact
      end

      def saved_attachments_data
        return nil if issue.saved_attachments.blank?

        attachments = issue.saved_attachments.map do |attachment|
          { id: attachment.id, name: attachment.filename, contentType: attachment.content_type }
        end
      end

      def attachments_data
        return nil if issue.attachments.blank?

        attachments = issue.attachments.map do |attachment|
          { id: attachment.id, name: attachment.filename, contentType: attachment.content_type }
        end
      end

      def field_changed?(key)
        issue.previous_changes.include?(key)
      end

      def notifiable_issue_field?(field)
        config.notifiable_issue_fields.include?(field)
      end

      def notifiable_custom_field?(field)
        config.notifiable_custom_field_ids.include?(field.id)
      end

      def issue_attribute_value(attribute)
        case attribute
        when 'project_id'
          issue.project.name
        when 'tracker_id'
          issue.tracker.name
        when 'author_id'
          issue.author_email
        when 'assigned_to_id'
          issue.assignee_email
        else
          issue.send(attribute.to_sym)
        end
      end

      def custom_field_value(custom_field)
        custom_field_value = issue.custom_field_values.find { |value| value.custom_field_id == custom_field.id }
        return "" if custom_field_value.blank?

        case custom_field.field_format
        when "list"
          custom_field.multiple? ? custom_field_value.value.join(', ') : custom_field_value.value
        when "bool"
          case custom_field_value.value
          when "0"
            "No"
          when "1"
            "Yes"
          else
            " - "
          end
        else
          custom_field_value.value
        end
      end
    end
  end
end
