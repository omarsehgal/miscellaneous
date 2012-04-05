class AddEmailToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :email, :string
  end

  def self.down
    remove_column :categories, :email
  end
end
