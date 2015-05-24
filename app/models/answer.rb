class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  include Votable
  include Attachable
  include Commentable

  validates :body, presence: true
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  after_create :calculate_rating

  def set_the_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      self.update(best: true)
    end
  end

  private
    def calculate_rating
      Reputation.delay.calculate(self)
    end
end
