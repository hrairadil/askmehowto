class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :set_question, only: [:index, :new, :show, :create, :destroy]
  before_action :set_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
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
