module Workforce
  VERSION = "1.0.2"

  mattr_accessor :logger

  def self.apply_patches
    Project.include Workforce::ProjectPatch
    Issue.include   Workforce::IssuePatch
    IssuesController.include Workforce::IssuesControllerPatch
    ProjectsController.helper Workforce::ProjectSettingTabsPatch
  end
end
