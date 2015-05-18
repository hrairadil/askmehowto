require 'rails_helper'

describe 'Profile APT' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:me) { create :user }
      let!(:users) { create_list :user, 4 }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains a list of users without me' do
        expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
        expect(response.body).not_to include_json(me.to_json)
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/profiles/', { format: :json }.merge(options)
  end
end
