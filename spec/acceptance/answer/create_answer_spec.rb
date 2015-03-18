require 'rails_helper'

feature 'User tries to create an answer to the question', %q{
  In order to be able to solve an issue
  As a user
  I want to be able to create an answer to the question
} do
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'Authenticated user tries to write an answer to the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'This is the best answer ever!'
    click_on 'Create answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'The answer has been successfully submitted.'
    within '.answers' do
      expect(page).to have_content 'This is the best answer ever!'
    end
  end

  scenario 'Authenticated user tries to write an empty answer to the question' do
    sign_in(user)
    visit question_answers_path(question)
    click_on 'Answer the question'
    fill_in 'Body', with: ' '
    click_on 'Create answer'

    expect(page).to have_content 'Unable to submit the answer!'
  end

  scenario 'Unauthenticated user tries to create an answer' do
    visit question_answers_path(question)
    expect(page).not_to have_link 'Answer the question'
    visit new_question_answer_path(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

end