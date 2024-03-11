class WorkforceConfiguration < ActiveRecord::Base
  belongs_to :project

  enum project_type: { helpdesk: 0 }

  def url
    Setting.plugin_workforce['url']
  end

  def email
    Setting.plugin_workforce['email']
  end

  def client
    Setting.plugin_workforce['client']
  end
end
