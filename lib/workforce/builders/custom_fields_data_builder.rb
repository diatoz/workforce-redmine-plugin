module Workforce
  module Builders
    class CustomFieldsDataBuilder
      attr_accessor :field, :payload

      def initialize(field)
        @field = field
        @payload = {}
      end

      def self.serialize(field)
        new(field).serialize
      end

      def serialize
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
