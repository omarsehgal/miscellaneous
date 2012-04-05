class AddYetAnotherColumnToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :sent_at, :datetime
  end

  def self.down
    remove_column :announcements, :sent_at
  end
end
