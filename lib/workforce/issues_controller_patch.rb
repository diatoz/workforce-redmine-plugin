module Workforce
  module IssuesControllerPatch
    extend ActiveSupport::Concern

    included do
      after_action :notify_workforce

      def notify_workforce
        return unless RequestStore.exist?(:notify_workforce) && @issue.can_notify_workforce?

        config = @issue.workforce_config
        if params[:action] == 'create'
          payload = Workforce::Builders::IssuePayloadBuilder.build_create_payload(@issue)
          response = Workforce::Client.create_ticket(config, payload)
        else
          payload = Workforce::Builders::IssuePayloadBuilder.build_update_payload(@issue)
          response = Workforce::Client.update_ticket(config, payload)
        end
      rescue => e
        Workforce.logger.error "Notification failed for issue id #{@issue.id}, reason: #{e.message}"
        Workforce.logger.error e.backtrace
      end
    end
  end
end
