class Like < ActiveRecord::Base
  belongs_to :answer
  belongs_to :likeable, :polymorphic => true

  def count(answer)
    return Like.find(:all, :conditions => [ "answer_id = ?", answer.id]).count
  end
end
