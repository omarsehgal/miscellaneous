class AddFiendsToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :team_id, :integer
    add_column :announcements, :email_list, :string
  end

  def self.down
    remove_column :announcements, :team_id, :integer
    remove_column :announcements, :email_list, :string
  end
end
