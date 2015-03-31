require_relative '../acceptance_helper'

feature 'Update files when update an answer', %q{
  In order to fix mistakes
  As an answer's author
  I'd like to be able to update attached files when update an answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, :with_attachments, question: question, user: user }
  given!(:attachment) { answer.attachments.first }


  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds several files when creates answer', js: true do
    within "#answer-#{answer.id}" do
      click_on 'Edit'
      click_on 'Add more'

      inputs = all('input[type="file"]')
      2.times { |i| inputs[i].set("#{Rails.root}/spec/fixtures/screenshot#{i}.jpg") }
      click_on 'Save'

      2.times { |i| expect(page).to have_link "screenshot#{i}.jpg" }
    end
  end
end