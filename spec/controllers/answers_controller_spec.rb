require 'rails_helper'

describe AnswersController do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  describe 'GET #index' do
    before { get :index, question_id: question }

    it 'assigns question.answers to @answers' do
      expect(assigns(:question).answers).to eq question.answers
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new, question_id: question}

    it 'assigns Answer.new to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'when valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, question_id: question, user_id: @user, answer: attributes_for(:answer) }
                              .to change(question.answers, :count).by(1)

      end

      it 'redirects to question show view' do
        post :create, question_id: question, user_id: @user, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when invalid attributes' do
      it 'does not save a new answer to the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer, :with_wrong_attributes)}
                              .to_not change(Answer, :count)
      end
      it 'redirects to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer, :with_wrong_attributes)
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:another_user) { create :user }
    let!(:authors_answer) { create :answer, question: question, user: @user }
    let!(:another_users_answer) { create :answer, question: question, user: another_user }

    context "author's answer" do

      it 'deletes authors answer from the database' do
        expect { delete :destroy, id: authors_answer, question_id: question }
            .to change(@user.answers, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, id: authors_answer, question_id: question
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context "another user's answer" do
      it "does not delete another user's answer" do
        expect { delete :destroy, id: another_users_answer, question_id: question }
            .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_users_answer, question_id: question
        expect(response).to redirect_to question
      end
    end
  end
end