require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to be able to fix mistakes
  As an author
  I'd like to have an opportunity to edit question
} do
  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }

  scenario 'Unauthenticated user tries to edit a question' do
    visit question_path(question)
    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'sees Edit link' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his own answer', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Question', with: 'edited question'
        click_on 'Save'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end
end

