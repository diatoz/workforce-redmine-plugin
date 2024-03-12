module Workforce
  module ProjectPatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_config, class_name: "WorkforceConfiguration"
    end
  end
end
