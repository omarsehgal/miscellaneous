class CreateApprovers < ActiveRecord::Migration
  def self.up
    create_table :approvers do |t|
      t.string :name
      t.string :idsid
      t.string :team

      t.timestamps
    end
  end

  def self.down
    drop_table :approvers
  end
end
