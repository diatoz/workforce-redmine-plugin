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

          if params[:action] == 'create'
            notify_created_relations
          elsif params[:action] == 'destroy'
            notify_destroyed_relation
          end
        rescue => e
          Workforce.logger.error "Failed to notify Workforce for issue #{@issue&.id} relations, reason: #{e.message}"
          Workforce.logger.error e.backtrace
        end

        private

        def notify_created_relations
          relations = RequestStore.store[:workforce_created_relations].presence
          return unless relations

          config = @issue.workforce_config
          return unless config.present?

          payload = Workforce::Builders::IssueRelationDataBuilder.build_create_payload(relations)
          Workforce::Client.create_ticket_relation(config, payload, User.current.id)
        end

        def notify_destroyed_relation
          return unless @relation.present?

          config = @relation.issue_from.workforce_config
          return unless config.present?

          Workforce::Client.destroy_ticket_relation(config, @relation.id.to_s, User.current.id)
        end
      end
    end
  end
end

unless IssueRelationsController.included_modules.include?(Workforce::Patches::IssueRelationsControllerPatch)
  IssueRelationsController.send(:include, Workforce::Patches::IssueRelationsControllerPatch)
end
