module Workforce
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      def workforce_field_format
        type = CUSTOM_FIELD_FORMAT_MAPPING[field_format]
        self.multiple ? "MULTI_SELECT" : type  # for field which can have multiple values
      end

      def workforce_supported_field?
        !CUSTOM_FIELD_NOT_SUPPORTED_FORMATS.include?(field_format)
      end
    end
  end
end
