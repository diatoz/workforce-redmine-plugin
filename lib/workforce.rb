module Workforce
  VERSION = "1.0.3"

  mattr_accessor :logger

  def self.apply_patches
    User.include Workforce::UserPatch
    Issue.include Workforce::IssuePatch
    Project.include Workforce::ProjectPatch
    IssuesController.include Workforce::IssuesControllerPatch
    ProjectsController.helper Workforce::ProjectSettingTabsPatch
  end
end
