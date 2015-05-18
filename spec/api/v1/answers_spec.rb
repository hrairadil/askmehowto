require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create :access_token }
  let(:question) { create :question }
  let!(:answers) { create_list :answer, 2, :with_comments, :with_attachments, question: question }
  let(:answer) { answers.first }
  let(:comment) { answer.comments.first }
  let(:attachment) { answer.attachments.first }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers",
                   format: :json,
                   access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns a list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body)
              .to be_json_eql(answer.send(attr.to_sym).to_json)
                      .at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
                   format: :json,
                   access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
                                       .at_path("answer/#{attr}")
        end
      end

      context 'comment' do
        it 'belongs to answer' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(id body commentable_id commentable_type user_id created_at updated_at).each do |attr|
          it "contain #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachment' do
        it 'belongs to question' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
          expect(response.body).to be_json_eql(attachment.file.url.to_json)
                                       .at_path('answer/attachments/0/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:post_attributes) {
        {
            answer: attributes_for(:answer),
            question_id: question,
            format: :json,
            access_token: access_token.token
        }
      }

      it 'returns 201 status code' do
        post "/api/v1/questions/#{question.id}/answers", post_attributes
        expect(response.status).to eq 201
      end

      it 'saves a question to the db' do
        expect{ post "/api/v1/questions/#{question.id}/answers", post_attributes }.to change(question.answers, :count).by(1)
      end
    end
  end

  def do_request(options = {})
    post "/api/v1/questions/#{question.id}/answers",
         {
             answer: attributes_for(:answer),
             question_id: question
         }.merge(options)
  end
end
