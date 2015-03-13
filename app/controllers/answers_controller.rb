class AnswersController < ApplicationController
  before_action :get_question, only: [ :new, :show, :create]

  def new
    @answer = @question.answers.new
  end

  def show
    @answer = @question.answers.find(params[:id])
    redirect_to question_answers_path(@question)
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path(@question)
    else
      render :new
    end

  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end

    def get_question
      @question = Question.find(params[:question_id])
    end
end
