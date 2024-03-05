module Workforce
  module ProjectPatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_detail, class_name: "WorkforceConfiguration"
    end
  end
end
