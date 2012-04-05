class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :name
      t.integer :team_id
      t.string :created_by
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
