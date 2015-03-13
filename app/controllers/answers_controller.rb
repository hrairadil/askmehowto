class AnswersController < ApplicationController
  before_action :get_question, only: [ :new, :show ]

  def new
    @answer = @question.answers.new
  end

  def show
    @answer = @question.answers.find(params[:id])
  end

  private
    def get_question
      @question = Question.find(params[:question_id])
    end
end
