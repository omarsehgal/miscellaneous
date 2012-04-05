class AddDefaultToAnswers < ActiveRecord::Migration
  def self.up
    change_column :answers, :tup, :integer, :default => 0
    change_column :answers, :tdown, :integer, :default => 0
  end

  def self.down
  end
end
