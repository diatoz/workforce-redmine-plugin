module Workforce
  module Patches
    module EmailAddressPatch
      extend ActiveSupport::Concern

      included do
        after_commit :notify_email_upsert_to_workforce, on: :update

        def notify_email_upsert_to_workforce
          return unless is_default && user.present?

          NotifyUserChangesToWorkforceJob.set(wait: 1.second).perform_later({ action: :update, user: user})
        end
      end
    end
  end
end

unless EmailAddress.included_modules.include?(Workforce::Patches::EmailAddressPatch)
  EmailAddress.send(:include, Workforce::Patches::EmailAddressPatch)
end
