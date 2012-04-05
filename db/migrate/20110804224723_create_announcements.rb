class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :content
      t.string :created_by

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
