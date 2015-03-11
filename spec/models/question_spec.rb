require 'rails_helper'
require 'shoulda-matchers'

describe Question do
  let(:question) { create :question }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end