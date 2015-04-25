class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  include Votable
  include Attachable

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
end
