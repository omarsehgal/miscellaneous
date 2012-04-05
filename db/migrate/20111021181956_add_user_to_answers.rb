class AddUserToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :user, :string
  end

  def self.down
    remove_column :answers, :user
  end
end
