module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:vote_up, :vote_down, :unvote]
    before_action :authorize_for_voting, only: [:vote_up, :vote_down]
  end

  def vote_up
    @resource.vote(current_user, 1)
    render :vote
  end

  def vote_down
    @resource.vote(current_user, -1)
    render :vote
  end

  def unvote
    @resource.unvote(current_user) if @resource.voted_by? current_user
    render :vote
  end

  private

    def authorize_for_voting
      if @resource.user == current_user || @resource.voted_by?(current_user)
        render status: :forbidden, text: 'forbidden action'
      end
    end

    def set_resource
      @resource = controller_name.classify.constantize.find(params[:id])
    end
end