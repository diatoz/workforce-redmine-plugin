namespace :workforce do
  desc "Create workforce configuration for all the projects"
  task :create_workforce_config_for_all_projects => :environment do
    Project.all.each do |project|
      unless project.workforce_config.present?
        project.generate_workforce_config
      end
    end
  end
end
