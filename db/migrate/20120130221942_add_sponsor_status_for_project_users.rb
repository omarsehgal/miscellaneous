class AddSponsorStatusForProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :sponsor_approved, :boolean
  end

  def self.down
    remove_column :project_users, :sponsor_approved
  end
end
