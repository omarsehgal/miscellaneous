class AddAttachmentToAnnouncement < ActiveRecord::Migration
  def self.up
    add_column :announcements, :file_name, :string
    add_column :announcements, :content_type, :string
    add_column :announcements, :file_size, :integer
  end

  def self.down
    remove_column :announcements, :file_name
    remove_column :announcements, :content_type
    remove_column :announcements, :file_size
  end
end
