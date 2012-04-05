class CreateProjectUsers < ActiveRecord::Migration
  def self.up
    create_table :project_users do |t|
      t.string :name
      t.string :usertype
      t.string :sponsor
      t.string :team
      t.text :justification
      t.integer :duration
      t.integer :diskspace

      t.timestamps
    end
  end

  def self.down
    drop_table :project_users
  end
end
