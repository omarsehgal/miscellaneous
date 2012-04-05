class ChangeAttachmentToAnnouncement < ActiveRecord::Migration
  def self.up
    rename_column :announcements, :file_name, :attachment_file_name
    rename_column :announcements, :content_type, :attachment_content_type
    rename_column :announcements, :file_size, :attachment_file_size
  end

  def self.down
  end
end
