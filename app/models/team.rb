class Team < ActiveRecord::Base
  has_many :categories
  has_many :members
  accepts_nested_attributes_for :categories
  validates :name, :presence => true, :uniqueness => true
end
