class Subject < ApplicationRecord
  has_many :questions
  has_many :tests

end
