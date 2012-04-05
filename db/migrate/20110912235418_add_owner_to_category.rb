class AddOwnerToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :owner, :string
  end

  def self.down
    remove_column :categories, :owner, :string
  end
end
