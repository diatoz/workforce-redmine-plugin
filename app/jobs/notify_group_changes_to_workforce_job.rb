class NotifyGroupChangesToWorkforceJob < ApplicationJob

  def perform(params)
    Workforce.logger.error "Notification group"
    config = WorkforceConfiguration.last
    case params[:action]
    when :create
      payload = Workforce::Builders::GroupDataBuilder.build_create_payload(params[:group])
      Workforce::Client.create_group(config, payload)
    when :update
      payload = Workforce::Builders::GroupDataBuilder.build_update_payload(params[:group])
      Workforce::Client.update_group(config, payload)
    end
  rescue => e
    Workforce.logger.error "Notification failed for group id #{params[:group].id}, reason: #{e.message}"
    Workforce.logger.error e.backtrace
  end
end
