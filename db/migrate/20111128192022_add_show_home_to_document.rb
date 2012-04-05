class AddShowHomeToDocument < ActiveRecord::Migration
  def self.up
     add_column :documents, :show_home, :boolean, :default => 0
  end

  def self.down
  end
end
