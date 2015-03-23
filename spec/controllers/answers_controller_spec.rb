require 'rails_helper'

describe AnswersController do
  let!(:user) { create :user }
  let!(:another_user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:answer) { create :answer, question: question, user: user }
  let!(:authors_answer) { create :answer, question: question, user: user }
  let!(:another_users_answer) { create :answer, question: question, user: another_user }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'when valid attributes' do
      let(:create_params) {{ answer: attributes_for(:answer),
                             question_id: question,
                             user_id: user,
                             format: :js }}

      it 'saves a new answer to the database' do
        expect { post :create, create_params }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, create_params
        expect(response).to render_template :create
      end
    end

    context 'when invalid attributes' do
      let(:wrong_create_params){{ answer: attributes_for(:answer, :with_wrong_attributes),
                                  question_id: question,
                                  user_id: user,
                                  format: :js }}

      it 'does not save a new answer to the database' do
        expect { post :create, wrong_create_params }
            .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, wrong_create_params
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }
    let(:update_params) {{ id: answer,
                           answer: attributes_for(:answer),
                           question_id: question,
                           user_id: user,
                           format: :js }}

    it 'assigns the requested answer to @answer' do
      patch :update, update_params
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, update_params
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, update_params.update(answer: { body: 'new body' })
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it "does not update another user's answer" do
      patch :update, id: another_users_answer,
                     answer: { body: 'should not update this body'} ,
                     question_id: question,
                     user_id: another_user,
                     format: :js

      another_users_answer.reload
      expect(another_users_answer.body).not_to eq 'should not update this body'
    end

    it 'render update template' do
      patch :update, update_params
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    context "author's answer" do

      it 'deletes authors answer from the database' do
        expect { delete :destroy, id: authors_answer, question_id: question, format: :js }
            .to change(user.answers, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, id: authors_answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "another user's answer" do
      it "does not delete another user's answer" do
        expect { delete :destroy, id: another_users_answer, question_id: question, format: :js }
            .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_users_answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end