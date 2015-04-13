class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  include Votable

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :attachments
end
