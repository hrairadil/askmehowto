require 'rails_helper'

describe AnswersController do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:user) { create :user }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'when valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, answer: attributes_for(:answer),
                               question_id: question,
                               user_id: user,
                               format: :js }
            .to change(question.answers, :count).by(1)

      end

      it 'renders create template' do
        post :create, { answer: attributes_for(:answer),
                      question_id: question,
                      user_id: user,
                      format: :js }

        expect(response).to render_template :create
      end
    end

    context 'when invalid attributes' do
      it 'does not save a new answer to the database' do
        expect { post :create, answer: attributes_for(:answer, :with_wrong_attributes),
                               question_id: question,
                               user_id: user,
                               format: :js }
            .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, { answer: attributes_for(:answer, :with_wrong_attributes),
                        question_id: question,
                        user_id: user,
                        format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    let!(:another_user) { create :user }
    let!(:authors_answer) { create :answer, question: question, user: user }
    let!(:another_users_answer) { create :answer, question: question, user: another_user }

    context "author's answer" do

      it 'deletes authors answer from the database' do
        expect { delete :destroy, id: authors_answer, question_id: question }
            .to change(user.answers, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, id: authors_answer, question_id: question
        expect(response).to redirect_to question
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