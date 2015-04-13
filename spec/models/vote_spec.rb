require 'rails_helper'
require 'shoulda-matchers'

describe Vote do
  it { should respond_to :value }

  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question }


  [:question, :answer].each do |resource_name|
    before { @resource = send resource_name }

    describe "#{@resource}" do
      context 'vote up' do
        it { expect{ @resource.vote user, 1 }.to change(@resource.votes, :count).by(1) }

        it 'changes value up to 1' do
          @resource.vote user, 1
          expect(@resource.votes.find_by(user: user).value).to eq 1
        end
      end

      context 'vote down' do
        it { expect{ @resource.vote user, -1 }.to change(@resource.votes, :count).by(1) }

        it 'changes value down to -1' do
          @resource.vote user, -1
          expect(@resource.votes.find_by(user: user).value).to eq -1
        end
      end
    end

  end
end