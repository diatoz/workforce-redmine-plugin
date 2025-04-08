namespace :workforce do
  desc "Configure workforce configuration for all the projects"
  task :configure_workforce_for_all_projects => :environment do
    Project.all.each do |project|
      workforce_config = project.workforce_config
      if workforce_config.present?
        workforce_config.update(
          is_enabled: true,
          issue_notifiable_columns: {
            "custom_field_ids" => project.all_issue_custom_fields.select(&:workforce_supported_field?).map(&:id),
            "issue_fields" => Workforce::ISSUE_SUPPORTED_ATTRIBUTES
          }.with_indifferent_access
        )
      else
        project.generate_workforce_config
      end
    end
  end
end
