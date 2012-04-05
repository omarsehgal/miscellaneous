class EditFieldsInMonitorActions < ActiveRecord::Migration
  def self.up
    remove_column :monitor_actions, :actionable_id
    remove_column :monitor_actions, :actionable_type
    add_column :monitor_actions, :monitor_item_id, :integer
  end

  def self.down
  end
end
