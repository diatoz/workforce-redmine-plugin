class RemoveTrackerIdFromWorkforceConfiguration < ActiveRecord::Migration[6.1]
  def change
     WorkforceConfiguration.all.each do |workforce_config|
      issue_fields = workforce_config.issue_notifiable_columns.with_indifferent_access[:issue_fields]
      if issue_fields.is_a?(Array) && issue_fields.include?('tracker_id')
        issue_fields.delete('tracker_id')
        workforce_config.issue_notifiable_columns.with_indifferent_access[:issue_fields] = issue_fields
        workforce_config.save
      end
    end
  end
end
