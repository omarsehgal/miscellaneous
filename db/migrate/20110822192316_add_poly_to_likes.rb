class AddPolyToLikes < ActiveRecord::Migration
  def self.up
    add_column :likes, :likeable_id, :integer
    add_column :likes, :likeable_type, :string
  end

  def self.down
    remove_column :likes, :likeable_id
    remove_column :likes, :likeable_type
  end
end
