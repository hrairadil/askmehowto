require 'rails_helper'

describe Question do
  let(:question) { create :question, :with_answers }

  it { should respond_to :title }
  it { should respond_to :body }

end