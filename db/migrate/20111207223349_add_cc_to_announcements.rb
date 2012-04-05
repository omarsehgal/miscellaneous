class AddCcToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :cc_list, :text
  end

  def self.down
    remove_column :announcements, :cc_list
  end
end
