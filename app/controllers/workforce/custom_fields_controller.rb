module Workforce
  class CustomFieldsController < ApplicationController
    before_action :authorize_workforce_user
    accept_api_auth :index

    def index
      data = []
      @issue_custom_fields = IssueCustomField.all
      @issue_custom_fields.each do |field|
        data << Workforce::Builders::CustomFieldPayloadBuilder.build_index_payload(field)
      end
      render json: { custom_fields: data.compact }
    end

    private

    def authorize_workforce_user
      deny_access unless User.current.workforce_user?
    end
  end
end
