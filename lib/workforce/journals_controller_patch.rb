module Workforce
  module JournalsControllerPatch
    extend ActiveSupport::Concern

    included do
      after_action :notify_workforce, :only => [:update]

      def notify_workforce
        return if User.current.workforce_user? || !RequestStore.exist?(:notify_workforce)
        return unless @journal.journalized.is_a?(Issue) && @journal.journalized.workforce_notifiable?

        config = @journal.journalized.workforce_config
        if @journal.destroyed?
          payload = Workforce::Builders::CommentsDataBuilder.build_destroy_payload(@journal)
          Workforce::Client.destroy_comment(config, payload)
        else
          payload = Workforce::Builders::CommentsDataBuilder.build_update_payload(@journal)
          Workforce::Client.update_comment(config, payload)
        end
      rescue => e
        Workforce.logger.error "Notification failed for comment id #{@journal.id}, reason: #{e.message}"
        Workforce.logger.error e.backtrace
      end
    end
  end
end
