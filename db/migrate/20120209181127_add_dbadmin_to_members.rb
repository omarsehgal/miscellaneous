class AddDbadminToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :dbadmin, :integer
  end

  def self.down
  end
end
