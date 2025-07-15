require_relative 'lib/workforce/hooks'

Redmine::Plugin.register :workforce do
  name 'Workforce plugin'
  author 'Workforce'
  description 'Workforce plugin for Redmine'
  version '1.1.5'
  url 'https://github.com/diatoz/workforce-redmine-plugin'
  author_url 'https://e2eworkforce.com/'

  settings(
    partial: 'settings/workforce_global_settings',
    default: {
      domain: '',
      email: '',
      ticket_endpoint: '',
      ticket_api_key: '',
      user_endpoint: '',
      user_api_key: ''
    }
  )

  permission :manage_workforce_configuration, workforce_configurations: [:create, :update]

  Workforce.logger = Logger.new(Rails.root.join('log/workforce.log'), 5, 30 * 1024 * 1024)
end

if (Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk) || Rails.version > '7.0'
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib/workforce/patches') }
end

Rails.configuration.after_initialize do
  Workforce.apply_patches
end
