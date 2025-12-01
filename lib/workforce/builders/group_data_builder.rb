module Workforce
  module Builders
    class GroupDataBuilder
      attr_accessor :group, :payload

      def initialize(group)
        @group = group
        @payload = {}
      end

      def self.build_create_payload(group)
        new(group).build_create_payload
      end

      def self.build_update_payload(group)
        new(group).build_update_payload
      end

      # --------------------------
      # CREATE PAYLOAD
      # --------------------------
      def build_create_payload
        payload[:extRefId]  = group.id
        payload[:name]      = group.name
        payload[:createdOn] = group.created_on.iso8601
        payload[:users]     = serialize_users
        payload.compact
      end

      # --------------------------
      # UPDATE PAYLOAD
      # --------------------------
      def build_update_payload
        payload[:extRefId]  = group.id
        payload[:name]      = group.name
        payload[:updatedOn] = group.updated_on.iso8601
        payload[:users]     = serialize_users
        payload.compact
      end

      # --------------------------
      # Helper: Serialize group members
      # --------------------------
      def serialize_users
        group.users.map do |u|
          { id: u.id, login: u.login, email: u.mail }
        end
      end

      # --------------------------
      # Helper: detect changed fields
      # --------------------------
      def field_changed?(attribute)
        group.previous_changes.include?(attribute)
      end
    end
  end
end
