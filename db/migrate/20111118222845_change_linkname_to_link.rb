class ChangeLinknameToLink < ActiveRecord::Migration
  def self.up
    rename_column :links, :link_name, :link
  end

  def self.down
  end
end
