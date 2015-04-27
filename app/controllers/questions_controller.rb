class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_questions, only: [:index, :update, :destroy]
  include Voted

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
      PrivatePub.publish_to '/questions', question: render_to_string(template: 'questions/submit.json.jbuilder')
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
