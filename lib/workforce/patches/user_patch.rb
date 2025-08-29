module Workforce
  module Patches
    module UserPatch
      extend ActiveSupport::Concern

      included do
        after_commit :notify_user_changes_to_workforce, on: [:create, :update]
        after_create :generate_personal_access_token_for_user

        def workforce_user?
          mail == Setting.plugin_workforce['email']
        end

        def notify_user_changes_to_workforce
          return unless ["id", "lastname", "firstname"].any? { |field| previous_changes.include?(field) }

          action = previous_changes.include?('id') ? :create : :update
          NotifyUserChangesToWorkforceJob.set(wait: 1.second).perform_later({ action: action, user: self })
        end

        def generate_personal_access_token_for_user
          create_api_token(:action => 'api')
        end
      end
    end
  end
end

unless User.included_modules.include?(Workforce::Patches::UserPatch)
  User.send(:include, Workforce::Patches::UserPatch)
end
