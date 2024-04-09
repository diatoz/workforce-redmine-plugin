class AddEnabledColumnToWorkforceConfigurations < ActiveRecord::Migration[6.1]
  def up
    add_column :workforce_configurations, :is_enabled, :boolean, default: false
  end

  def down
    remove_column :workforce_configurations, :is_enabled
  end
end
