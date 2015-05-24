class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy

  include Votable
  include Attachable
  include Commentable

  after_create :update_reputation

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  private

  def update_reputation
    self.delay.calculate_reputation
  end

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update_attributes(reputation: reputation)
  end
end
