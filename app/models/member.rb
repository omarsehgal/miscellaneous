class Member < ActiveRecord::Base
  belongs_to :team
  validates :idsid, :presence => true, :uniqueness => true
  validates :team_id, :presence => true
  validates :name, :presence => true
  validates :coverage_area, :presence => true
end
