class AnswersController < ApplicationController
  before_action :set_question, only: [ :index, :new, :show, :create]

  def index
  end

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
      flash[:success] = 'The answer has been successfully submitted.'
      redirect_to question_answers_path(@question)
    else
      flash[:danger] = 'Unable to submit the answer!'
      render :new
    end

  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end

    def set_question
      @question = Question.find(params[:question_id])
    end
end
