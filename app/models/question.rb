class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy

  include Votable
  include Attachable
  include Commentable

  after_create :calculate_reputation

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  private

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
