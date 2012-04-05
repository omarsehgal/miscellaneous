class AddTeamLeadToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :team_lead, :integer
  end

  def self.down
    remove_column :members, :team_lead
  end
end
