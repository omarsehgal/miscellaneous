class AddFieldsToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :title, :string
    add_column :announcements, :att_path, :string
    add_column :announcements, :project_id, :integer
    add_column :announcements, :category_id, :integer
  end

  def self.down
    remove_column :announcements, :title
    remove_column :announcements, :att_path
    remove_column :announcements, :project_id
    remove_column :announcements, :category_id
  end
end
