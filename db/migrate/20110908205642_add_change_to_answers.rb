class AddChangeToAnswers < ActiveRecord::Migration
  def self.up
    rename_column :answers, :file_name, :attachment_file_name
    rename_column :answers, :content_type, :attachment_content_type
    rename_column :answers, :file_size, :attachment_file_size
  end

  def self.down
  end
end
