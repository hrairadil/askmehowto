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
      flash[:success] = 'Question has been successfully created!'
      redirect_to @question
    else
      flash[:danger] = 'Can not create your question! Parameters are invalid!'
      render :new
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      flash[:success] = 'Question has been successfully deleted!'
      redirect_to questions_path
    else
      flash[:danger] = "Can not delete question"
      redirect_to @question
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
