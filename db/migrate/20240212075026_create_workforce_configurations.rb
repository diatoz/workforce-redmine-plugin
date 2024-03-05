class CreateWorkforceConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :workforce_configurations do |t|
      t.references :project, foregin_key: true
      t.string :api_key
      t.integer :project_type, default: 0

      t.timestamps
    end
  end
end
