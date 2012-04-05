class AddDescriptionToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :description, :text
  end

  def self.down
    remove_column :servers, :description
  end
end
