require 'rails_helper'

describe QuestionsController do
  let(:question) { create :question }

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not save question to the database' do
        expect { post :create, question: attributes_for(:question, :with_wrong_attributes) }
            .to_not change(Question, :count)
      end
      it 'renders new view' do
        post :create, question: attributes_for(:question, :with_wrong_attributes)
        expect(response).to render_template :new
      end
    end
  end
end
