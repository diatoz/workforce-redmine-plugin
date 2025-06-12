class WorkforceConfiguration < ActiveRecord::Base
  belongs_to :project

  before_save :sanitize_issue_notifiable_data

  serialize :issue_notifiable_columns, ActiveSupport::HashWithIndifferentAccess

  enum project_type: { helpdesk: 0 }

  CONFIG_KEYS = %i[
    domain
    email
    ticket_endpoint
    ticket_api_key
    user_endpoint
    user_api_key
  ].freeze

  CONFIG_KEYS.each do |key|
    define_method(key) do
      global_config[key]
    end
  end

  def global_config
    @global_config ||= Setting.plugin_workforce
  end

  def notifiable_issue_fields
    Workforce::ISSUE_MANDATORY_ATTRIBUTES + (issue_notifiable_columns.try('[]', 'issue_fields') || [])
  end

  def notifiable_custom_field_ids
    (issue_notifiable_columns.try('[]', 'custom_field_ids') || []).map(&:to_i)
  end

  def sanitize_issue_notifiable_data
    issue_notifiable_columns[:issue_fields].reject!(&:blank?)
    issue_notifiable_columns[:custom_field_ids].reject!(&:blank?)
  end
end
