class DropSponsorManager < ActiveRecord::Migration
  def self.up
    drop_table :sponsor_managers
  end

  def self.down
  end
end
