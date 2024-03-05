class WorkforceConfigurationsController < ApplicationController
  before_action :set_project

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
    workforce_configuration = WorkforceConfiguration.find(workforce_configuration_params[:id])
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
    params.require(:workforce_configuration).permit(:id, :project_id, :api_key, :project_type)
  end

  def set_project
    @project = Project.find(workforce_configuration_params[:project_id])
  end
end
