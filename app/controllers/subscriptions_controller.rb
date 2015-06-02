class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy]
  before_action :set_subscription, only: :destroy

  authorize_resource
  respond_to :js

  def create
    authorize! :subscribe_to, @question
    respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private
    def set_question
      @question = Question.find(params[:question_id])
    end

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end
end
