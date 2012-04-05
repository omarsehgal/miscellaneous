class CreateAddrBooks < ActiveRecord::Migration
  def self.up
    create_table :addr_books do |t|
      t.string :name
      t.string :email
      t.string :idsid
      t.string :type
      t.string :created_by

      t.timestamps
    end
  end

  def self.down
    drop_table :addr_books
  end
end
