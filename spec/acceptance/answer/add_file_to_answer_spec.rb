require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answers the question', js: true do
    fill_in 'create-answer-body', with: 'This is the best answer ever!'
    attach_file 'File', "#{Rails.root}/spec/fixtures/screenshot.jpg"
    click_on 'Create answer'
    within '.answers' do
      expect(page).to have_link 'screenshot.jpg', href: '/uploads/attachment/file/1/screenshot.jpg'
    end
  end
end