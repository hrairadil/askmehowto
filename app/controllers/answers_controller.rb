class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :set_the_best]
  before_action :set_question, only: [ :create, :update, :destroy, :set_the_best]
  before_action :authorize_user, only: [:update, :destroy]
  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render :submit
    else
      render_errors
    end
  end

  def update
    if @answer.update(answer_params)
      render :submit
    else
      render_errors
    end
  end

  def destroy
    @answer.destroy!
  end

  def set_the_best
    @answer.set_the_best if @question.user == current_user
  end

  private
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_question
      @question = params.has_key?(:question_id) ? Question.find(params[:question_id]) : @answer.question
    end

    def authorize_user
      redirect_to root_path unless @answer.user == current_user
    end

    def render_errors
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
end
