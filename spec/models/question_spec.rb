require 'rails_helper'
require 'shoulda-matchers'

describe Question do
  let(:question) { create :question, :with_answers }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should have_many :answers }
end