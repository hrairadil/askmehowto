require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create :access_token }
  let(:question) { create :question }
  let!(:answers) { create_list :answer, 2, :with_comments, :with_attachments, question: question }
  let(:answer) { answers.first }
  let(:comment) { answer.comments.first }
  let(:attachment) { answer.attachments.first }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

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
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

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
  end
end