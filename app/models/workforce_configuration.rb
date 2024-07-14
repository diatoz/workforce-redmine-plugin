class WorkforceConfiguration < ActiveRecord::Base
  belongs_to :project

  before_save :sanitize_issue_notifiable_data

  serialize :issue_notifiable_columns, ActiveSupport::HashWithIndifferentAccess

  enum project_type: { helpdesk: 0 }

  ISSUE_MANDATORY_ATTRIBUTES = %w[subject description status_id priority_id due_date].freeze
  ISSUE_SUPPORTED_ATTRIBUTES = %w[project_id tracker_id author_id assigned_to_id start_date done_ratio estimated_hours].freeze

  def domain
    Setting.plugin_workforce['domain']
  end

  def email
    Setting.plugin_workforce['email']
  end

  def notifiable_issue_fields
    ISSUE_MANDATORY_ATTRIBUTES + (issue_notifiable_columns.try('[]', 'issue_fields') || [])
  end

  def notifiable_custom_field_ids
    (issue_notifiable_columns.try('[]', 'custom_field_ids') || []).map(&:to_i)
  end

  def sanitize_issue_notifiable_data
    issue_notifiable_columns[:issue_fields].reject!(&:blank?)
    issue_notifiable_columns[:custom_field_ids].reject!(&:blank?)
  end

  def supported_custom_field_format?(field)
    !(['user', 'version'].include?(field.field_format) || field.multiple == true)
  end
end
