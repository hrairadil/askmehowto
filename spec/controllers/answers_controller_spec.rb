require 'rails_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:another_question) { create :question, :with_answers, user: another_user }
  let!(:answer) { create :answer, question: question, user: user }
  let!(:authors_answer) { create :answer, question: question, user: user }
  let!(:another_users_answer) { create :answer, question: question, user: another_user }
  let(:voted_answer) { another_question.answers.take }
  let!(:vote_params) {{ id: voted_answer,
                       question_id: another_question,
                       format: :json}}


  describe 'POST #create' do
    before { sign_in(user) }

    context 'when valid attributes' do
      let(:create_params) {{ answer: attributes_for(:answer),
                             question_id: question,
                             user_id: user,
                             format: :json }}

      it 'saves a new answer to the database' do
        expect { post :create, create_params }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, create_params
        expect(response).to render_template :submit
      end
    end

    context 'when invalid attributes' do
      let(:wrong_create_params){{ answer: attributes_for(:answer, :with_wrong_attributes),
                                  question_id: question,
                                  user_id: user,
                                  format: :json }}

      it 'does not save a new answer to the database' do
        expect { post :create, wrong_create_params }
            .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, wrong_create_params
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }
    let(:update_params) {{ id: answer,
                           answer: attributes_for(:answer),
                           user_id: user,
                           format: :json }}

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
                     user_id: another_user,
                     format: :json

      another_users_answer.reload
      expect(another_users_answer.body).not_to eq 'should not update this body'
    end

    it 'render update template' do
      patch :update, update_params
      expect(response).to render_template :submit
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    context "author's answer" do

      it 'deletes authors answer from the database' do
        expect { delete :destroy, id: authors_answer, format: :js }
            .to change(user.answers, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, id: authors_answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "another user's answer" do
      it "does not delete another user's answer" do
        expect { delete :destroy, id: another_users_answer, format: :js }
            .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_users_answer, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #set_the_best' do
    before { sign_in(user) }

    context "if author's question" do
      before do
        patch :set_the_best, id: another_users_answer, format: :js
      end

      it 'sets the best answer' do
        another_users_answer.reload
        expect(another_users_answer).to be_best
      end

      it 'renders set_the_best template' do
        expect(response).to render_template :set_the_best
      end
    end

    context "if another user's question" do
      before do
        patch :set_the_best, id: another_question.answers.first, format: :js
      end

      it 'does not set the best answer' do
        another_question.answers.first.reload
        expect(another_question.answers.first).not_to be_best
      end

      it 'renders set_the_best template' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #vote_up' do
    context 'User' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_up, vote_params }.to change(voted_answer.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_up, vote_params
        vote = voted_answer.votes.find_by(user: user)
        expect(vote.value).to eq 1
      end

      it 'renders vote json template ' do
        patch :vote_up, vote_params
        expect(response).to render_template :vote
      end

      it 'denies voting second time' do
        patch :vote_up, vote_params
        patch :vote_down, vote_params
        vote = voted_answer.votes.find_by(user: user)
        expect(vote.value).to eq 1
      end
    end

    context 'Author' do
      before { sign_in(user) }
      let(:params) {{ id: answer, format: :json }}

      it { expect{ patch :vote_up, params }.not_to change(answer.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, params
        expect(response).to redirect_to root_path
      end
    end

    context 'Guest' do
      it 'votes for answer' do
        expect{ patch :vote_up, vote_params }.not_to change(voted_answer.votes, :count)
      end

      it 'renders vote json template ' do
        patch :vote_up, vote_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'User' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_down, vote_params }.to change(voted_answer.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_down, vote_params
        voted_answer.reload
        vote = voted_answer.votes.find_by(user: user)
        expect(vote.value).to eq -1
      end

      it 'denies voting second time' do
        patch :vote_down, vote_params
        patch :vote_up, vote_params
        vote = voted_answer.votes.find_by(user: user)
        expect(vote.value).to eq -1
      end

      it 'renders vote json template ' do
        patch :vote_down, vote_params
        expect(response).to render_template :vote
      end
    end

    context 'Author' do
      before { sign_in(user) }

      it { expect{ patch :vote_down, id: answer, format: :json }
               .not_to change(answer.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, id: answer, format: :json
        expect(response).to redirect_to root_path
      end
    end

    context 'Guest' do
      it 'votes for answer' do
        expect{ patch :vote_down, vote_params }.not_to change(voted_answer.votes, :count)
      end

      it 'renders status unauthorized' do
        patch :vote_down, vote_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #unvote' do
    context 'User' do
      before do
        sign_in(user)
        patch :vote_up, vote_params
      end

      it { expect{ patch :unvote, vote_params }
               .to change(voted_answer.votes, :count).by(-1) }

      it 'renders vote json template' do
        patch :unvote, vote_params
        expect(response).to render_template :vote
      end
    end

    context 'Author' do
      before { sign_in(user) }

      it 'can not unvote' do
        expect{ patch :unvote, id: answer, format: :json}.not_to change(answer.votes, :count)
      end
    end

    context 'Guest' do
      it 'can not unvote' do
        expect{ patch :unvote, vote_params }.not_to change(voted_answer.votes, :count)
      end

      it 'renders status unauthorized' do
        patch :unvote, id: answer, format: :json
        expect(response).to be_unauthorized
      end
    end
  end
end