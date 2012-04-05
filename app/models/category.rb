class Category < ActiveRecord::Base
  belongs_to :team
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  validates :name, :presence => true, :uniqueness => true
  validates :owner, :presence => true
  validates :team_id, :presence => true

  def has_owner?(owner)
    if !self.owner.nil?
      owners = self.owner.split(',')
      return owners.include?(owner)
    end
  end
end
