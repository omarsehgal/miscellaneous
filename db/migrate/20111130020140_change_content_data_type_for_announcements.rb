class ChangeContentDataTypeForAnnouncements < ActiveRecord::Migration
  def self.up
    change_column :announcements, :content, :text
  end

  def self.down
  end
end
