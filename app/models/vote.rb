class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true
  validates :value, inclusion: [-1, 1]
end
