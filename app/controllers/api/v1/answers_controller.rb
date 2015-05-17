class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: :index

  def index
    respond_with @answers = @question.answers.all
  end

  private
    def set_question
      @question = Question.find(params[:question_id])
    end
end