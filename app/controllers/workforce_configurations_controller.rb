class WorkforceConfigurationsController < ApplicationController
  before_action :set_project

  def create
    config = WorkforceConfiguration.new(config_params)
    flash[:notice] = (
      if config.save
        l(:workforce_settings_update_success)
      else
        l(:workforce_settings_update_failed)
      end
    )
    redirect_to settings_project_path(@project, :tab => 'workforce')
  end

  def update
    config = WorkforceConfiguration.find(params[:id])
    flash[:notice] = (
      if config.update(config_params)
        l(:workforce_settings_update_success)
      else
        l(:workforce_settings_update_failed)
      end
    )
    redirect_to settings_project_path(@project, :tab => 'workforce')
  end

  private

  def config_params
    params.require(:workforce_configuration).permit(:project_id, :api_key, :project_type, :is_enabled, issue_notifiable_columns: {custom_field_ids: [], issue_fields: []})
  end

  def set_project
    @project = Project.find(config_params[:project_id])
  end
end
