class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_questions, only: [:index, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]
  after_action :publish, only: :create

  include Voted

  respond_to :html, :js
  respond_to :json, only: :create

  def index
    respond_with @questions
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    respond_with @question
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Question has been successfully created!'
    else
      flash[:alert] = 'Can not create your question! Parameters are invalid!'
    end
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    flash.now[:notice] = 'Question has been successfully deleted!'
    respond_with(@question.destroy)
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

    def authorize_user
      redirect_to root_path unless @question.user == current_user
    end

    def publish
      PrivatePub.publish_to '/questions', question: render_to_string(template: 'questions/submit.json.jbuilder') if @question.valid?
    end
end
