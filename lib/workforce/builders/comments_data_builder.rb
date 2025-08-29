module Workforce
  module Builders
    class CommentsDataBuilder
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

      def self.build_destroy_payload(journal, deleter)
        new(journal).build_destroy_payload(deleter)
      end

      def build_create_payload
        payload[:extRefId] = journal.journalized_id
        payload[:messageId] = journal.id
        payload[:message] = journal.notes
        payload[:createdById] = journal.user_id
        payload
      end

      def build_update_payload
        payload[:messageId] = journal.id
        payload[:message] = journal.notes
        payload[:lastModifiedId] = journal.updated_by_id
        payload
      end

      def build_destroy_payload(deleter = nil)
        payload[:messageId] = journal.id
        payload[:deletedById] = deleter&.id
        payload
      end
    end
  end
end
