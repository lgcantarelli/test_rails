class Test < ApplicationRecord
  belongs_to :subject #, counter_cache: true, inverse_of: :questions
  has_many :test_questions
  has_many :questions, through: :test_questions

  # accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  # scope :_search_questions_from_subjects_, ->( subject_id){
  #   Question.includes(:questions, :subject).where(subject_id: subject_id)
  # }
end
