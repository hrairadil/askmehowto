require 'rails_helper'

describe Answer do
  let(:answer) { create :answer }

  it { should respond_to :body }
  it { should respond_to :question_id }
end