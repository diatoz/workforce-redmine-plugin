module Workforce
  class CustomApiController < ApplicationController
    before_action :authorize_workforce_user
    accept_api_auth :custom_fields, :create_journal, :issues

    def custom_fields
      data = IssueCustomField.all.map do |field|
        Workforce::Builders::CustomFieldsDataBuilder.serialize(field)
      end
      render json: { custom_fields: data.compact }
    end

    def create_journal
      head :bad_request and return unless params[:issue_id].present? && params[:notes].present?

      issue = Issue.find(params[:issue_id])
      journal = issue.init_journal(User.current, params[:notes])
      journal.save!
      render json: { message_id: journal.id }
    rescue ActiveRecord::RecordNotFound
      head :not_found
    rescue StandardError
      head :unprocessable_entity
    end

    def issues
      head :bad_request and return if params[:id].blank?

      issue = Issue.find(params[:id])
      render json: Workforce::Builders::IssuesDataBuilder.serialize(issue)
    rescue ActiveRecord::RecordNotFound
      head :not_found
    rescue StandardError
      head :unprocessable_entity
    end

    private

    def authorize_workforce_user
      deny_access unless User.current.workforce_user?
    end
  end
end
