module Workforce
  module Builders
    class IssuePayloadBuilder
      attr_accessor :issue, :payload

      def initialize(issue)
        @issue = issue
        @payload = {}
      end

      def self.build_create_payload(issue)
        new(issue).build_create_payload
      end

      def self.build_update_payload(issue)
        new(issue).build_update_payload
      end

      def build_create_payload
        payload[:extRefId]         = issue.id
        payload[:extTktSrc]        = 'REDMINE'
        payload[:title]            = issue.subject
        payload[:description]      = issue.description
        payload[:reportedByEmail]  = issue.author_email
        payload[:primaryAssignee]  = issue.assignee_email
        payload[:ticketStatusId]   = issue.status_id
        payload[:ticketTypeId]     = issue.tracker_id
        payload[:ticketPriorityId] = issue.priority_id
        payload[:customFields]     = custom_fields_data
        payload[:dueDate]          = issue.due_date.try(:iso8601)
        payload[:createdDate]      = issue.created_on.iso8601
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload.compact!
      end

      def build_update_payload
        payload[:extRefId]         = issue.id
        payload[:extTktSrc]        = 'REDMINE'
        payload[:title]            = issue.subject                if changes_include?(:subject)
        payload[:description]      = issue.description            if changes_include?(:description)
        payload[:reportedByEmail]  = issue.author_email           if changes_include?(:author_id)
        payload[:primaryAssignee]  = issue.assignee_email         if changes_include?(:assigned_to_id)
        payload[:ticketTypeId]     = issue.tracker_id             if changes_include?(:tracker_id)
        payload[:ticketStatusId]   = issue.status_id              if changes_include?(:status_id)
        payload[:ticketPriorityId] = issue.priority_id            if changes_include?(:priority_id)
        payload[:dueDate]          = issue.due_date.try(:iso8601) if changes_include?(:due_date)
        payload[:customFields]     = custom_fields_data
        payload[:lastModifiedDate] = issue.updated_on.iso8601
        payload.compact!
      end

      def custom_fields_data
        nil
      end

      def changes_include?(key)
        issue.previous_changes.include?(key)
      end
    end
  end
end
