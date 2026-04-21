module Workforce
  module Patches
    module IssueRelationPatch
      extend ActiveSupport::Concern

      included do
        after_commit :track_workforce_created_relation, on: :create

        private

        def track_workforce_created_relation
          return unless RequestStore.store[:notify_workforce]

          RequestStore.store[:workforce_created_relations] ||= []
          RequestStore.store[:workforce_created_relations] << self
        end
      end
    end
  end
end

unless IssueRelation.included_modules.include?(Workforce::Patches::IssueRelationPatch)
  IssueRelation.send(:include, Workforce::Patches::IssueRelationPatch)
end
