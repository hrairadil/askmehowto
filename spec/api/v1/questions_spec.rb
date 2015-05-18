require 'rails_helper'

describe 'Questions API' do
  let(:user) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: user.id }
  let!(:questions) { create_list :question, 2 }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }

      before { get '/api/v1/questions',
                   format: :json,
                   access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body)
              .to be_json_eql(question.send(attr.to_sym).to_json)
                      .at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at user_id best).each do |attr|
          it "contains #{attr}" do
            expect(response.body)
                .to be_json_eql(answer.send(attr.to_sym).to_json)
                        .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: question }
    let!(:attachment) { create :attachment, attachable: question }

    it_behaves_like 'API Authenticable'

    context 'authorized' do

      before { get "/api/v1/questions/#{question.id}",
                   format: :json,
                   access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                       .at_path("question/#{attr}")
        end
      end

      context 'comment' do
        it 'belongs to question' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body commentable_id commentable_type user_id created_at updated_at).each do |attr|
          it "contain #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachment' do
        it 'belongs to question' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
          expect(response.body).to be_json_eql(attachment.file.url.to_json)
                                     .at_path('question/attachments/0/url')
        end
      end
    end


    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:post_attributes) {
        {
          question: attributes_for(:question),
          format: :json,
          access_token: access_token.token
        }
      }

      it 'returns 201 status code' do
        post '/api/v1/questions/', post_attributes
        expect(response.status).to eq 201
      end

      it 'saves a question to the db' do
        expect{ post '/api/v1/questions/', post_attributes }.to change(Question, :count).by(1)
      end
    end
  end

  def do_request(options = {})
    post '/api/v1/questions/', { question: attributes_for(:question), format: :json }.merge(options)
  end
end

