class CreateWorkforceAudits < ActiveRecord::Migration[6.1]
  def change
    create_table :workforce_audits do |t|
      t.references :source, polymorphic: true
      t.string :action
      t.string :error_message
      t.text :error_backtrace

      t.timestamps
    end
  end
end
