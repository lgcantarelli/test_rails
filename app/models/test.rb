class Test < ApplicationRecord
  belongs_to :subject
  has_many :test_questions
  has_many :questions, through: :test_questions
end
