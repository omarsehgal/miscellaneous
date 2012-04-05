class ChangeTypeInServers < ActiveRecord::Migration
  def self.up
    rename_column :servers, :type, :category
  end

  def self.down
  end
end
