class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question has been successfully created!'
    else
      flash.now[:alert] = 'Can not create your question! Parameters are invalid!'
      render :new
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy!
      redirect_to questions_path, notice: 'Question has been successfully deleted!'
    else
      redirect_to @question, alert: 'Can not delete question'
    end
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
