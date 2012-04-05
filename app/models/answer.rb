class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :likes, :as => :likeable
  has_attached_file :attachment
  #validates_attachment_content_type :attachment, :content_type => ["application/pdf", "image/jpg", "image/gif", "application/mspowerpoint", "application/excel"]
#  validates_attachment_content_type :attachment, :content_type => ["application/pdf"], :message => "file must be of filetype pdf"

  def like
    Like.create(:answer => self)
  end

  def tup_change
    self.tup += 1
  end

  def tdown_change
    self.tdown += 1
  end

end
