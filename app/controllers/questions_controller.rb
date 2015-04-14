class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy, :vote_up, :vote_down]
  before_action :set_questions, only: [:index, :update, :destroy]

  def index
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
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

  def update
    @question.update(question_params) if @question.user == current_user
  end

  def destroy
    if @question.user == current_user
      flash.now[:notice] = 'Question has been successfully deleted!' if @question.destroy!
    else
      flash.now[:alert] = 'This action is restricted'
    end
  end

  def vote_up
    @question.vote(current_user, 1)
    render :vote
  end

  def vote_down
    @question.vote(current_user, -1)
    render :vote
  end

  private
    def set_questions
      @questions = Question.all
    end

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
