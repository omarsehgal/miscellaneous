class AddShowHomeToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :show_home, :boolean, :default => 0
  end

  def self.down
  end
end
