require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question with valid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body'
    click_on 'Create'
    expect(page).to have_content 'Question has been successfully created!'
    expect(page).to have_content 'Test Title'
    expect(page).to have_content 'Test Body'
  end

  scenario 'Authenticated user tries to create a question with invalid parameters' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ' '
    fill_in 'Body', with: ' '
    click_on 'Create'
    expect(page).to have_content 'Can not create your question! Parameters are invalid!'
  end

  scenario 'Unauthenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end