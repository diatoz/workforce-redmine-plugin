module Workforce
  class Message
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def notify
      url = source.workforce_detail.url
      key = source.workforce_detail.api_key
      message = workforce_issue_message
      Workforce::Api.notify(url, key, message)
    end

    def workforce_issue_message
      {
        title: source.subject,
        orgId:  "647756f114e71e60dc17d3db",
        description: source.description,
        reportedByEmail: source.workforce_detail.email,
        reportedById: '65e562ce1d283251fd6602b3',
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
