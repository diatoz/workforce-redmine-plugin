module Workforce
  module Patches
    module IssueRelationsControllerPatch
      extend ActiveSupport::Concern

      included do
        before_action :set_workforce_notify_flag
        after_action :notify_issue_relation_changes, only: [:create, :destroy]

        def set_workforce_notify_flag
          header_value = request.headers['X-Notify-Workforce'].to_s.strip.downcase
          if header_value == 'disable'
            RequestStore.store[:notify_workforce] = false
          else
            RequestStore.store[:notify_workforce] = true
          end
        end

        def notify_issue_relation_changes
          return if User.current.workforce_user?
          return unless RequestStore.store[:notify_workforce]
          return unless @relation.present?

          config = @relation.issue.workforce_config

          if params[:action] == 'create'
            payload = Workforce::Builders::IssueRelationDataBuilder.build_create_payload(@relation)
            Workforce::Client.create_ticket_relation(config, payload, User.current.id)
          elsif params[:action] == 'destroy'
            Workforce::Client.destroy_ticket_relation(config, @relation.id.to_s, User.current.id)
          end
        rescue => e
          Workforce.logger.error "Failed to notify Workforce for relation id #{@relation&.id}, reason: #{e.message}"
          Workforce.logger.error e.backtrace
        end
      end
    end
  end
end

unless IssueRelationsController.included_modules.include?(Workforce::Patches::IssueRelationsControllerPatch)
  IssueRelationsController.send(:include, Workforce::Patches::IssueRelationsControllerPatch)
end
