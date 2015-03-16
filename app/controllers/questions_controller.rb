class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:success] = 'Question has been successfully created!'
      redirect_to @question
    else
      flash[:danger] = 'Can not create your question! Parameters are invalid!'
      render :new
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
