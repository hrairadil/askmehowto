 require 'rails_helper'

describe QuestionsController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }
  let(:another_question) { create :question, user: another_user }
  let(:vote_params) {{ id: another_question,
                        format: :json}}


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

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    before{ sign_in(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, question: attributes_for(:question) }
                               .to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question to the database' do
        expect { post :create, question: attributes_for(:question, :with_wrong_attributes) }
            .to_not change(user.questions, :count)
      end

      it 'renders new view' do
        post :create, question: attributes_for(:question, :with_wrong_attributes)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }
    let!(:authors_question) { create :question, user: user }
    let!(:another_user) { create :user, :with_questions }
    let(:update_params) {{ id: question,
                           question: attributes_for(:question),
                           user_id: user,
                           format: :js }}

    it 'assigns question to @question' do
      patch :update, update_params
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, update_params.update(question: { title: 'new title', body: 'new body'})
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'does not change another users question' do
      question = another_user.questions.first
      patch :update, id: question,
                     question: { title: 'new title', body: 'new body'},
                     user_id: another_user,
                     format: :js
      question.reload
      expect(question.title).not_to eq 'new title'
      expect(question.body).not_to eq 'new body'
    end

    it 'renders update template' do
      patch :update, update_params
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }
    let!(:authors_question) { create :question, user: user }
    let!(:another_user) { create :user, :with_questions }

    context 'author' do
      it 'deletes authors question from the database' do
        expect { delete :destroy, id: authors_question, format: :js }
            .to change(user.questions, :count).by(-1)
      end

      it 'assigns questions to @questions' do
        delete :destroy, id: authors_question, format: :js
        expect(assigns(:questions)).to eq Question.all
      end

      it 'renders index view' do
        delete :destroy, id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'another user' do
      it "does not delete another user's question" do
        expect { delete :destroy, id: another_user.questions.first, format: :js }
            .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_user.questions.first, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #vote_up' do
    context 'when signed in user' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_up, vote_params }.to change(another_question.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_up, vote_params
        question.reload
        expect(another_question.votes.first.value).to eq 1
      end

      it 'denies voting second time' do
        patch :vote_up, vote_params
        patch :vote_down, vote_params
        expect(another_question.votes.first.value).to eq 1
      end

      it 'renders vote json template ' do
        patch :vote_up, vote_params
        expect(response).to render_template :vote
      end
    end

    context 'when signed in as author' do
      before { sign_in(user) }

      let(:params) {{ id: question, format: :json }}

      it { expect{ patch :vote_up, params }.not_to change(question.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, params
        expect(response).to be_forbidden
      end
    end

    context 'when guest' do
      it 'votes for answer' do
        expect{ patch :vote_up, vote_params }.not_to change(another_question.votes, :count)
      end

      it 'renders vote json template ' do
        patch :vote_up, vote_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'when signed in user' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_down, vote_params }.to change(another_question.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_down, vote_params
        question.reload
        expect(another_question.votes.first.value).to eq -1
      end

      it 'denies voting second time' do
        patch :vote_down, vote_params
        patch :vote_up, vote_params
        expect(another_question.votes.first.value).to eq -1
      end

      it 'renders vote json template ' do
        patch :vote_down, vote_params
        expect(response).to render_template :vote
      end
    end

    context 'when signed in as author' do
      before { sign_in(user) }

      let(:params) {{ id: question, format: :json }}

      it { expect{ patch :vote_down, params }.not_to change(question.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, params
        expect(response).to be_forbidden
      end
    end

    context 'when guest' do
      it 'votes for answer' do
        expect{ patch :vote_down, vote_params }.not_to change(another_question.votes, :count)
      end

      it 'renders vote json template ' do
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
               .to change(another_question.votes, :count).by(-1) }

      it 'renders vote json template' do
        patch :unvote, vote_params
        expect(response).to render_template :vote
      end
    end

    context 'Author' do
      before { sign_in(user) }

      it 'can not unvote' do
        expect{ patch :unvote, id: question, format: :json}.not_to change(question.votes, :count)
      end
    end

    context 'Guest' do
      it 'can not unvote' do
        expect{ patch :unvote, vote_params }.not_to change(another_question.votes, :count)
      end

      it 'renders status unauthorized' do
        patch :unvote, id: question, format: :json
        expect(response).to be_unauthorized
      end
    end
  end
end
