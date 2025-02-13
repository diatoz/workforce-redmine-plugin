module Workforce
  module ProjectPatch
    extend ActiveSupport::Concern

    included do
      has_one :workforce_config, class_name: "WorkforceConfiguration"

      after_create :generate_workforce_config

      def generate_workforce_config
        create_workforce_config(
          project_type: 0,
          is_enabled: true,
          issue_notifiable_columns: { "custom_field_ids" => [], "issue_fields" => [] }.with_indifferent_access
        )
      end
    end
  end
end
