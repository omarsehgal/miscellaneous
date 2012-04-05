class CreateMonitorActions < ActiveRecord::Migration
  def self.up
    create_table :monitor_actions do |t|
      t.string :name
      t.string :category
      t.text :script
      t.text :description
      t.string :created_by
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :monitor_actions
  end
end
