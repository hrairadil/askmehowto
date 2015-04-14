module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:vote_up, :vote_down]
  end

  def vote_up
    @resource.vote(current_user, 1)
    render :vote
  end

  def vote_down
    @resource.vote(current_user, -1)
    render :vote
  end

  private

    def set_resource
      @resource = controller_name.classify.constantize.find(params[:id])
    end
end