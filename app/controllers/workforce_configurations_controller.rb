class WorkforceConfigurationsController < ApplicationController
  before_action :find_project, :authorize

  def create
    workforce_configuration = WorkforceConfiguration.new(workforce_configuration_params)
    flash[:notice] = (
      if workforce_configuration.save
        l(:workforce_settings_update_success)
      else
        l(:workforce_settings_update_failed)
      end
    )
    redirect_to settings_project_path(@project, :tab => 'workforce')
  end

  def update
    workforce_configuration = WorkforceConfiguration.find(params[:id])
    flash[:notice] = (
      if workforce_configuration.update(workforce_configuration_params)
        l(:workforce_settings_update_success)
      else
        l(:workforce_settings_update_failed)
      end
    )
    redirect_to settings_project_path(@project, :tab => 'workforce')
  end

  private

  def workforce_configuration_params
    params.require(:workforce_configuration).permit(:project_id, :api_key, :project_type, :is_enabled)
  end

  def find_project
    @project = Project.find(workforce_configuration_params[:project_id])
  end
end
