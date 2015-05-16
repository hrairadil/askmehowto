class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: :show
  before_action :set_questions, only: :index

  def index
    respond_with @questions
  end

  def show
    respond_with @question
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def set_questions
      @questions = Question.all
    end
end