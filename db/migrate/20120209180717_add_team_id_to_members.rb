class AddTeamIdToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :team_id, :integer
  end

  def self.down
  end
end
