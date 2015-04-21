require_relative '../acceptance_helper'

feature 'Comment a question', %q{
  In order to be able to specify a question
  As an authenticated user
  I'd like to have an opportunity to comment a question
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates a comment', js: true do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Body', with: 'New comment'
        click_on 'Submit'
        expect(page).to have_content 'New comment'
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can not comment a question' do
      within '.question' do
        expect(page).not_to have_link 'Add comment'
      end
    end
  end
end