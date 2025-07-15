module Workforce
  module Builders
    class UserDataBuilder
      attr_reader :user, :payload

      def initialize(user)
        @user = user
        @payload = {}
      end

      def self.build_create_payload(user)
        new(user).build_upsert_payload
      end

      def self.build_update_payload(user)
        new(user).build_upsert_payload
      end

      def self.build_destroy_payload(user)
        new(user).build_destroy_payload
      end

      def build_upsert_payload
        payload[:externalReferenceId] = user.id
        payload[:firstName] = user.firstname
        payload[:lastName] = user.lastname
        payload[:email] = user.mail
        payload.compact
      end

      def build_destroy_payload
        payload[:externalReferenceId] = user.id
        payload.compact
      end
    end
  end
end
