require 'rails_helper'
require 'shoulda-matchers'

describe Question do
  let(:question) { create :question }
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should respond_to :user_id }
  it { should respond_to :title }
  it { should respond_to :body }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }
end