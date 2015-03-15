require 'rails_helper'

feature 'User create question', %q{
  In order to be able to solve the issue
  As a user
  I want to be able to create a question
} do
  scenario 'user tries to create a question' do
    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body'
    click_on 'Create question'
    expect(page).to have_content 'Test Title'
    expect(page).to have_content 'Test Body'
  end
end