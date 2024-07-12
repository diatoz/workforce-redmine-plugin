class WorkforceConfiguration < ActiveRecord::Base
  belongs_to :project

  serialize :issue_notifiable_columns, ActiveSupport::HashWithIndifferentAccess

  enum project_type: { helpdesk: 0 }

  WORKFORCE_MANDATORY_ATTRIBUTES = %w[subject description status_id priority_id due_date]
  WORKFORCE_SUPPORTED_ATTRIBUTES = %w[project_id tracker_id author_id assigned_to_id start_date done_ratio estimated_hours]

  def domain
    Setting.plugin_workforce['domain']
  end

  def email
    Setting.plugin_workforce['email']
  end

  def notifiable_custom_field_ids
    (issue_notifiable_columns.try('[]', 'custom_field_ids') || []).map(&:to_i)
  end

  def notifiable_custom_field_ids=(value)
    issue_notifiable_columns[:custom_field_ids] = value.is_a?(Array) ? value : [value]
  end

  def notifiable_issue_fields
    WORKFORCE_MANDATORY_ATTRIBUTES + (issue_notifiable_columns.try('[]', 'issue_fields') || [])
  end

  def notifiable_issue_fields=(value)
    issue_notifiable_columns[:issue_fields] = value.is_a?(Array) ? value : [value]
  end
end
