class CreateSponsorManagers < ActiveRecord::Migration
  def self.up
    create_table :sponsor_managers do |t|
      t.string :name
      t.string :team

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsor_managers
  end
end
