class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  include Votable

  validates :body, presence: true
  validates :question_id, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def set_the_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      self.update(best: true)
    end
  end

end
