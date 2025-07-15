class NotifyUserChangesToWorkforceJob < ApplicationJob

  def perform(params)
    config = WorkforceConfiguration.last
    case params[:action]
    when :create
      payload = Workforce::Builders::UserDataBuilder.build_create_payload(params[:user])
      Workforce::Client.create_user(config, payload)
    when :update
      payload = Workforce::Builders::UserDataBuilder.build_update_payload(params[:user])
      Workforce::Client.update_user(config, payload)
    end
  rescue => e
    Workforce.logger.error "Notification failed for user id #{params[:user].id}, reason: #{e.message}"
    Workforce.logger.error e.backtrace
  end
end
