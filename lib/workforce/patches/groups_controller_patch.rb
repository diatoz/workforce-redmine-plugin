module Workforce
  module Patches
    module GroupsControllerPatch
      extend ActiveSupport::Concern

      included do
        before_action :set_workforce_notify_flag
        after_action :notify_group_changes, only: [:create, :update, :add_users, :remove_user]
        
        def set_workforce_notify_flag
          header_value = request.headers['X-Notify-Workforce'].to_s.strip.downcase
          if header_value == 'disable'
            RequestStore.store[:notify_workforce] = false
          else
            RequestStore.store[:notify_workforce] = true
          end
        end

        def notify_group_changes
          return if User.current.workforce_user?
          return unless RequestStore.store[:notify_workforce]
          return unless @group.present?
          
          if params[:action] == 'create'
            NotifyGroupChangesToWorkforceJob.perform_later(
              action: :create,
              group: @group
            )
          elsif params[:action] == 'update' || params[:action] == 'add_users' || params[:action] == 'remove_user'
            NotifyGroupChangesToWorkforceJob.perform_later(
              action: :update,
              group: @group
            )
          end
        rescue => e
          Workforce.logger.error "Failed to notify Workforce for group id #{@group&.id}, reason: #{e.message}"
          Workforce.logger.error e.backtrace
        end
      end
    end
  end
end

unless GroupsController.included_modules.include?(Workforce::Patches::GroupsControllerPatch)
  GroupsController.send(:include, Workforce::Patches::GroupsControllerPatch)
end
