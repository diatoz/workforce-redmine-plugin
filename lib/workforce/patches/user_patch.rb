require_dependency 'user'

module Workforce
  module Patches
    module UserPatch
      extend ActiveSupport::Concern

      included do
        def workforce_user?
          mail == Setting.plugin_workforce['email']
        end
      end
    end
  end
end

unless User.included_modules.include?(Workforce::Patches::UserPatch)
  User.send(:include, Workforce::Patches::UserPatch)
end
