class AddAdminToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :admin, :string
  end

  def self.down
    remove_column :teams, :admin
  end
end
