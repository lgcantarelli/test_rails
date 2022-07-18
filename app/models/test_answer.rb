class TestAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :test
  belongs_to :question
  belongs_to :answer
end
