class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_profile
  has_many :user_tests
  has_many :tests, through: :user_tests
  accepts_nested_attributes_for :user_profile, reject_if: :all_blank

  # callback do activerecord

  after_create :set_statistic


  #validations
  validates :first_name, presence: true, length: { minimum: 2 }, on: :update

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  private

  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_questions])
  end
   
end
