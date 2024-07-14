class AddIssueNotifiableColumnsToWorkforceConfigurations < ActiveRecord::Migration[6.1]
  def up
    add_column :workforce_configurations, :issue_notifiable_columns, :text
  end

  def down
    remove_column :workforce_configurations, :issue_notifiable_columns
  end
end
