require 'rails_helper'
require 'shoulda-matchers'

describe Answer do
  let(:answer) { create :answer }

  it { should respond_to :body }
  it { should respond_to :best }
  it { should respond_to :question_id }
  it { should belong_to :question }
  it { should validate_presence_of :body}
  it { should validate_presence_of :question_id}

  describe 'the best' do
    let(:question) { create :question}
    let(:best_answer) { create :answer, question: question }

    it 'should be set to true' do
      best_answer.set_the_best
      best_answer.reload
      expect(best_answer.best).to eq true
    end
  end
end