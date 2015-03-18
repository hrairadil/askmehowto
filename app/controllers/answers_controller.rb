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
      redirect_to question_answers_path(@question),
                  notice: 'The answer has been successfully submitted.'
    else
      flash.now[:alert] = 'Unable to submit the answer!'
      render :new
    end

  end

  def destroy
    if @answer.user == current_user
      @answer.destroy!
      redirect_to question_answers_path(@question),
                  notice: 'Answer has been successfully deleted!'
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
