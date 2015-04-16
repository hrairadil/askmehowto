require 'rails_helper'
require 'shoulda-matchers'

describe Answer do
  let!(:question) { create :question, :with_all_the_best_answers }
  let!(:another_question) { create :question, :with_all_the_best_answers }
  let!(:best_answer) { create :answer, question: question }
  let!(:another_best_answer) { create :answer, question: another_question }

  it { should respond_to :body }
  it { should respond_to :best }
  it { should respond_to :question_id }

  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  describe 'the best' do
    before do
      best_answer.set_the_best
      best_answer.reload
    end

    it 'sets to true' do
      expect(best_answer.best).to eq true
    end

    it 'is unique for one question' do
      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'is not unique for several questions' do
      another_best_answer.set_the_best
      another_best_answer.reload
      expect(Answer.where(best: true).count).to eq 2
    end

    it 'should be first' do
      expect(question.answers.first).to eq best_answer
    end
  end
end
