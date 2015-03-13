require 'rails_helper'

describe AnswersController do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  describe 'GET #new' do

    before { get :new, question_id: question}

    it 'assigns Answer.new to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { get :show, question_id: question, id: answer}

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders :show view' do
      expect(response).to render_template :show
    end
  end
end
