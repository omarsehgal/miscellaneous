class AddDbOnlyColumnForLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :DbTeam, :boolean
  end

  def self.down
    remove_column :links, :DbTeam
  end
end
