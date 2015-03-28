require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }

  background do
    sign_in(user)
    visit questions_path
  end

  scenario 'User adds file when asks question' do
    click_on 'Ask question'
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body'
    attach_file 'File', "#{Rails.root}/spec/acceptance/fixtures/screenshot.jpg"
    click_on 'Create'

    expect(page).to have_link 'screenshot.jpg', href: '/uploads/attachment/file/1/screenshot.jpg'
  end
end