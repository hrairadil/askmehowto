class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [ :create, :update, :destroy]
  before_action :set_answer, only: [:update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if @answer.user == current_user
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy!
      redirect_to @question, notice: 'Answer has been successfully deleted!'
    else
      redirect_to @question, notice: 'This action is restricted!'
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end

    def set_answer
      @answer = @question.answers.find(params[:id])
    end

    def set_question
      @question = Question.find(params[:question_id])
    end
end
