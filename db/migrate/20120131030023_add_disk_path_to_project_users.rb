class AddDiskPathToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :disk_path, :string
  end

  def self.down
    remove_column :project_users, :disk_path
  end
end
