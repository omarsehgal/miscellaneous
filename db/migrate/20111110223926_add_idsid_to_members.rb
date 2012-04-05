class AddIdsidToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :idsid, :string
  end

  def self.down
    remove_column :members, :idsid
  end
end
