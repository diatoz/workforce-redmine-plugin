module Workforce
  module Builders
    class CustomFieldPayloadBuilder
      attr_accessor :field, :payload

      def initialize(field)
        @field = field
        @payload = {}
      end

      def self.build_index_payload(field)
        new(field).build_index_payload
      end

      def build_index_payload
        return nil unless field.workforce_supported_field?

        payload[:id]             = field.id
        payload[:name]           = field.name
        payload[:fieldFormat]    = field.workforce_field_format
        payload[:possibleValues] = field.possible_values.presence
        payload.compact
      end
    end
  end
end
