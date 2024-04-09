class WorkforceConfiguration < ActiveRecord::Base
  belongs_to :project

  enum project_type: { helpdesk: 0 }

  def domain
    Setting.plugin_workforce['domain']
  end

  def email
    Setting.plugin_workforce['email']
  end
end
