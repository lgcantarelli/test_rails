class AddGradeToUserTest < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tests, :grade, :float
  end
end
