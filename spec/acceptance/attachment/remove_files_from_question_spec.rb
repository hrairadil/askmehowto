require_relative '../acceptance_helper'

feature 'Remove files from question', %q{
  In order to get rid of unnecessary attachments
  As an author of a question
  I'd like to be able to remove files from the question
} do
  given!(:author){ create :user }
  given!(:question){ create :question, :with_attachments, user: author }
  given!(:attachment) { question.attachments.first }

  background do
    sign_in(author)
    visit question_path(question)
  end

  scenario 'Author sees remove link' do
    expect(page).to have_link 'Delete file'
  end

  scenario 'Author removes files', js: true do
    within "#file-#{attachment.id}" do
      click_on 'Delete file'
    end
    expect(page).not_to have_content attachment.file.identifier
    expect(current_path).to eq question_path(question)
  end

  scenario "Author can not remove another user's files"
end