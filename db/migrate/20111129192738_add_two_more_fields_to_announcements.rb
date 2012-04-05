class AddTwoMoreFieldsToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :from_email, :string
    add_column :announcements, :status, :string
  end

  def self.down
    remove_column :announcements, :from_email
    remove_column :announcements, :status
  end
end
