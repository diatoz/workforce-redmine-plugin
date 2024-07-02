module Workforce
  module ProjectSettingTabsPatch
    def project_settings_tabs
      super.tap do |tabs|
        if User.current.allowed_to?(:manage_workforce_configuration, @project)
          tabs.push(
            {
              name: 'workforce',
              partial: 'projects/settings/workforce_project_setting_tab',
              label: :workforce_project_tab
            }
          )
        end
      end
    end
  end
end
