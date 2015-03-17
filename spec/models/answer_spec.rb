require 'rails_helper'
require 'shoulda-matchers'

describe Answer do
  let(:answer) { create :answer }

  it { should respond_to :body }
  it { should respond_to :question_id }
  it { should belong_to :question }
  it { should validate_presence_of :body}
  it { should validate_presence_of :question_id}
end