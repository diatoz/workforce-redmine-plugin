Redmine::Plugin.register :workforce do
  name 'Workforce plugin'
  author 'Workforce'
  description 'Workforce plugin for Redmine'
  version '1.0.1'
  url 'https://github.com/diatoz/workforce-redmine-plugin'
  author_url 'https://e2eworkforce.com/'

  settings partial: 'settings/workforce_global_settings', default: { email: '', url: '' }

  Workforce.apply_patches
  Workforce.logger = Logger.new(Rails.root.join('log/workforce.log'))
end
