 require 'rails_helper'

describe QuestionsController do
  let(:question) { create :question }

  describe 'GET #index' do
    let(:questions) { create_list :question, 2 }
    before { get :index }

    it 'assigns the list of all questions to @questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

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
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, question: attributes_for(:question) }
                               .to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question to the database' do
        expect { post :create, question: attributes_for(:question, :with_wrong_attributes) }
            .to_not change(@user.questions, :count)
      end

      it 'renders new view' do
        post :create, question: attributes_for(:question, :with_wrong_attributes)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:authors_question) { create :question, user: @user }
    let!(:another_user) { create :user, :with_questions }

    context "author's question" do

      it 'deletes authors question from the database' do
        expect { delete :destroy, id: authors_question }
            .to change(@user.questions, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, id: authors_question
        expect(response).to redirect_to root_path
      end
    end

    context "another user's question" do
      it "does not delete another user's question" do
        expect { delete :destroy, id: another_user.questions.first }
                                  .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_user.questions.first
        expect(page).to render_template :show, id: another_user.questions.first
      end
    end
  end
end
