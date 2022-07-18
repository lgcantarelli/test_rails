class AddWeightToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :weight, :integer
  end
end
