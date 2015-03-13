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
      expect(response).to redirect_to question_answers_path(question)
    end
  end

  describe 'POST #create' do
    context 'when valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }
                              .to change(question.answers, :count).by(1)

      end

      it 'renders show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'when invalid attributes' do
      it 'does not save a new answer to the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, :with_wrong_attributes)}
                              .to_not change(question.answers, :count)
      end
      it 'redirects to answers new action' do
        post :create, question_id: question, answer: attributes_for(:answer, :with_wrong_attributes)
        expect(response).to render_template :new
      end
    end
  end
end
