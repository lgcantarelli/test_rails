class RenameQuestionsIdToQuestionId < ActiveRecord::Migration[5.2]
  def change
    rename_column :test_questions, :questions_id, :question_id
  end
end
