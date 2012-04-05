class RenameUserTypeInProjectUsers < ActiveRecord::Migration
  def self.up
    rename_column :project_users, :usertype, :user_type
  end

  def self.down
  end
end
