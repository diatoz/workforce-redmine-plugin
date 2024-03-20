module Workforce
  module ProjectSettingTabsPatch
    def project_settings_tabs
      super.tap do |tabs|
        tabs.push(
          {
            name: 'workforce',
            partial: 'workforce/project_settings_tab',
            label: :workforce_project_tab
          }
        )
      end
    end
  end
end
