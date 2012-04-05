class AddFieldToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :tup, :integer
    add_column :answers, :tdown, :integer
  end

  def self.down
    remove_column :answers, :tup
    remove_column :answers, :tdown
  end
end
