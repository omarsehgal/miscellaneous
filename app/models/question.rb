class Question < ActiveRecord::Base
  belongs_to :category
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  define_index do
    indexes content
    indexes answers.content, :as => :answer_content
    indexes [category.name], :as => :category_name
  end

#  searchable do
#    text :content
#  end
end
