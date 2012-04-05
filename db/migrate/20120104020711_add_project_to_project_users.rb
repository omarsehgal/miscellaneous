class AddProjectToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :project, :string
  end

  def self.down
    remove_column :project_users, :project
  end
end
