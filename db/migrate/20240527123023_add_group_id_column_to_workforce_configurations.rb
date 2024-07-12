class AddGroupIdColumnToWorkforceConfigurations < ActiveRecord::Migration[6.1]
  def up
    add_column :workforce_configurations, :group_id, :string
  end

  def down
    remove_column :workforce_configurations, :group_id
  end
end
