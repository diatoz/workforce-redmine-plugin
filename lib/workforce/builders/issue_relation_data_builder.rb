module Workforce
  module Builders
    class IssueRelationDataBuilder
      attr_accessor :relations, :payload

      def initialize(relations)
        @relations = Array(relations)
        @payload = {}
      end

      def self.build_create_payload(relations)
        new(relations).build_create_payload
      end

      def build_create_payload
        payload[:issueId]  = relations.first.issue_from_id.to_s
        payload[:relations] = relations.map do |r|
          {
            extRefId:      r.id.to_s,
            issueId:       r.issue_from_id.to_s,
            issueToId:     r.issue_to_id.to_s,
            relationType:  r.relation_type,
            delay:         r.delay
          }.compact
        end
        payload
      end
    end
  end
end
