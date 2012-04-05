class AddUserToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :user, :string
  end

  def self.down
    remove_column :questions, :user, :string

  end
end
