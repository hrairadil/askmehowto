module Voted
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.value = value
    vote.save!
  end
end