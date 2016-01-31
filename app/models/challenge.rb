class Challenge < ApplicationRecord
  MAX_NUMBER_OF_USERS = 5

  class ChallengeAlreadyFullException < Exception; end

  belongs_to :user
  has_many   :user_challenges,  dependent: :destroy
  has_many   :users,            through: :user_challenges, source: :user

  validates :user,         presence: true
  validates :name,         presence: true
  validates :segment_id,   presence: true
  validates :segment_name, presence: true
  validates :end_time,     presence: true

  def add user
    unless user.is_a? User
      raise TypeError.new('user must be a User object')
    end

    transaction do
      if user_challenges.count >= MAX_NUMBER_OF_USERS
        raise ChallengeAlreadyFullException.new
      end

      user_challenges.create user: user
    end
  end
end