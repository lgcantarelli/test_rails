class TestQuestion < ApplicationRecord
  belongs_to :test
  belongs_to :question
  has_many :test_questions
end
