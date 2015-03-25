class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :question_id, presence: true
  validates :user_id, presence: true

  def set_the_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update(best: true)
    end
  end
end
