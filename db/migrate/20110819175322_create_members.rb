class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :coverage_area
      t.string :ooo_info
      t.string :fav_snack
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
