Redmine::Plugin.register :workforce do
  name 'Workforce plugin'
  author 'Workforce'
  description 'Workforce plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/diatoz/workforce-redmine-plugin'
  author_url 'https://e2eworkforce.com/'

  settings partial: 'settings/workforce_global_settings', default: { email: '', url: '' }

  Project.include Workforce::ProjectPatch
  Issue.include   Workforce::IssuePatch
  ProjectsController.send(:helper, Workforce::ProjectSettingTabsPatch)
end
