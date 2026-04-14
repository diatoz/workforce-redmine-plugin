module Workforce
  module Builders
    class IssueRelationDataBuilder
      attr_accessor :relation, :payload

      def initialize(relation)
        @relation = relation
        @payload = {}
      end

      def self.build_create_payload(relation)
        new(relation).build_create_payload
      end

      def self.build_destroy_payload(relation)
        new(relation).build_destroy_payload
      end

      def build_create_payload
        payload[:extRefId]      = relation.id.to_s
        payload[:issue_id]      = relation.issue_id.to_s
        payload[:issue_to_ids]  = [relation.issue_to_id.to_s]
        payload[:relation_type] = relation.relation_type
        payload[:delay]         = relation.delay
        payload.compact
      end

      def build_destroy_payload
        payload[:extRefId] = relation.id.to_s
        payload
      end
    end
  end
end
