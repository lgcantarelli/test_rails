class RemoveQuestionAndAnswerFromUserTest < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_tests, :question
    remove_column :user_tests, :answer
  end
end
