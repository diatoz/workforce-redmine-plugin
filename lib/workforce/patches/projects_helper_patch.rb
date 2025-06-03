module Workforce
  module Patches
    module ProjectsHelperPatch
      extend ActiveSupport::Concern

      included do
        def project_settings_tabs_with_workforce
          tabs = project_settings_tabs_without_workforce
          if User.current.allowed_to?(:manage_workforce_configuration, @project)
            tabs.push(
              {
                name: 'workforce',
                partial: 'projects/settings/workforce_project_setting_tab',
                label: :workforce_project_tab
              }
            )
          end
          tabs
        end

        class_eval do
          alias_method :project_settings_tabs_without_workforce, :project_settings_tabs
          alias_method :project_settings_tabs, :project_settings_tabs_with_workforce
        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include?(Workforce::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, Workforce::Patches::ProjectsHelperPatch)
end
