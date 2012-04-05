class AddFieldsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :site, :string
    add_column :members, :projects, :string
  end

  def self.down
    remove_column :members, :site
    remove_column :members, :projects
  end
end
