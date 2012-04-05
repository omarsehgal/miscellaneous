class AddAttachmentToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :file_name, :string
    add_column :answers, :content_type, :string
    add_column :answers, :file_size, :integer
  end

  def self.down
    remove_column :answers, :file_name
    remove_column :answers, :content_type
    remove_column :answers, :file_size
  end
end
