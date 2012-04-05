class AddCategoryToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :category, :string
  end

  def self.down
    remove_column :links, :category
  end
end
