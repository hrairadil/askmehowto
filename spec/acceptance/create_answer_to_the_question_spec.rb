require 'rails_helper'

feature 'User tries to create an answer to the question', %q{
  In order to be able to solve an issue
  As a user
  I want to be able to create an answer to the question
} do

  given(:question) { create :question }

  scenario 'User tries to write an answer to the question' do
    visit new_question_answer_path(question)

    fill_in 'Body', with: 'This is the best answer ever!'
    click_on 'Create answer'

    expect(page).to have_content 'The answer has been successfully submitted.'
    expect(page).to have_content 'This is the best answer ever!'
  end

  scenario 'User tries to write an empty answer to the question' do
    visit new_question_answer_path(question)

    fill_in 'Body', with: ' '
    click_on 'Create answer'

    expect(page).to have_content 'Unable to submit the answer!'
  end
end