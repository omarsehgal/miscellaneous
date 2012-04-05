class ChangeTypeNameForAddrBook < ActiveRecord::Migration
  def self.up
    rename_column :addr_books, :type, :category
  end

  def self.down
  end
end
