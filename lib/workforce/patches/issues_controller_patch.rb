require_dependency 'issues_controller'

module Workforce
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        after_action :notify_workforce, :only => [:create, :update]

        def notify_workforce
          return if User.current.workforce_user?
          return unless RequestStore.exist?(:notify_workforce) && @issue.workforce_notifiable?

          config = @issue.workforce_config
          if params[:action] == 'create'
            payload = Workforce::Builders::IssuesDataBuilder.build_create_payload(@issue, config)
            Workforce::Client.create_ticket(config, payload)
          elsif params[:action] == 'update' && @issue.has_workforce_notifiable_changes?
            payload = Workforce::Builders::IssuesDataBuilder.build_update_payload(@issue, config)
            Workforce::Client.update_ticket(config, payload)
          end
          return unless @issue.current_journal.present? && @issue.current_journal.notes.present?

          payload = Workforce::Builders::CommentsDataBuilder.build_create_payload(@issue.current_journal)
          Workforce::Client.create_comment(config, payload)
        rescue => e
          Workforce.logger.error "Notification failed for issue id #{@issue.id}, reason: #{e.message}"
          Workforce.logger.error e.backtrace
        end
      end
    end
  end
end

unless IssuesController.included_modules.include?(Workforce::Patches::IssuesControllerPatch)
  IssuesController.send(:include, Workforce::Patches::IssuesControllerPatch)
end
