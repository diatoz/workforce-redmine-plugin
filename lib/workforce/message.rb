module Workforce
  class Message
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def notify
      if source.previous_changes.include?(:id)
        Workforce::Api.notify(
          url: source.workforce_config.url,
          api_key: source.workforce_config.api_key,
          message: issue_post_message
        )
      end
    end

    def issue_post_message
      {
        title: source.subject,
        description: source.description,
        reportedByEmail: source.workforce_config.email,
        primaryAssignee: source.assignee_email,
        otherAssignees: nil,
        ticketStatusId: source.status_id,
        ticketTypeId: source.tracker_id,
        ticketPriorityId: source.priority_id,
        groupId: nil,
        tags: nil,
        createdDate: source.created_on.iso8601,
        lastModifiedDate: source.updated_on.iso8601,
        dueDate: source.due_date.try(:iso8601),
        surveyFormId: nil,
        surveyFormUrl: nil,
        categoryId: nil,
        accountId: nil,
        extRefId: source.id,
        extTktSrc: 'REDMINE'
      }.to_json
    end
  end
end
