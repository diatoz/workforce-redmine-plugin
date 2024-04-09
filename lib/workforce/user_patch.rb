module Workforce
  module UserPatch
    extend ActiveSupport::Concern

    included do
      def workforce_user?
        mail == Setting.plugin_workforce['email']
      end
    end
  end
end
