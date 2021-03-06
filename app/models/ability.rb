class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :search, Search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :subscribe_to, [Question] do |question|
      !question.followed_by(user).present?
    end
    can :update, [Question, Answer], user: user

    can :destroy, [Question, Answer, Comment, Subscription], user: user
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end

    can [:vote_up, :vote_down], [Answer, Question] do |resource|
      (resource.user_id != user.id) && !resource.voted_by?(user)
    end

    can :unvote, [Answer, Question] do |resource|
      (resource.user_id != user.id) && resource.voted_by?(user)
    end

    can :set_the_best, Answer do |answer|
      answer.question.user_id == user.id
    end
  end
end
