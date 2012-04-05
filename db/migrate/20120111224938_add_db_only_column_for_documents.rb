class AddDbOnlyColumnForDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :DbTeam, :boolean
  end

  def self.down
    remove_column :documents, :DbTeam
  end
end
