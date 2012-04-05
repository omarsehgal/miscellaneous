class CreateMonitorItems < ActiveRecord::Migration
  def self.up
    create_table :monitor_items do |t|
      t.string :name
      t.integer :team_id
      t.string :category
      t.text :description
      t.string :created_by

      t.timestamps
    end
  end

  def self.down
    drop_table :monitor_items
  end
end
