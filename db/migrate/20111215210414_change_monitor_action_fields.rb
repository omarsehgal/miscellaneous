class ChangeMonitorActionFields < ActiveRecord::Migration
  def self.up
    add_column :monitor_actions, :actionable_id, :integer
    add_column :monitor_actions, :actionable_type, :string
    remove_column :monitor_actions, :category
  end

  def self.down
    remove_column :monitor_actions, :actionable_id
    remove_column :monitor_actions, :actionable_type
  end
end
