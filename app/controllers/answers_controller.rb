class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :set_question, only: [:index, :new, :show, :create, :destroy]
  before_action :set_answer, only: [:destroy]


  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'The answer has been successfully submitted.'
      redirect_to question_answers_path(@question)
    else
      flash[:danger] = 'Unable to submit the answer!'
      render :new
    end

  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      flash[:success] = 'Answer has been successfully deleted!'
      redirect_to question_answers_path(@question)
    else
      flash[:danger] = 'This action is restricted!'
      redirect_to @question
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
