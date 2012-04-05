class DropServersTable < ActiveRecord::Migration
  def self.up
    drop_table :servers
  end

  def self.down
  end
end
