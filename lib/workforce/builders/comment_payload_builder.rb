module Workforce
  module Builders
    class CommentPayloadBuilder
      attr_accessor :journal, :payload

      def initialize(journal)
        @journal = journal
        @payload = {}
      end

      def self.build_create_payload(journal)
        new(journal).build_create_payload
      end

      def self.build_update_payload(journal)
        new(journal).build_update_payload
      end

      def build_create_payload
        payload[:extRefId] = journal.journalized_id
        payload[:message] = journal.notes
        payload
      end

      def build_update_payload
        nil
      end
    end
  end
end
