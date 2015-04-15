require_relative '../acceptance_helper'

feature 'Vote for question', %q{
  In order to answer the most liked question
  As an authenticated user
  I'd like to have an opportunity to vote for question
} do
  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { create :question, user: author }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up', js: true do
      within '.question' do
        click_on 'vote up'
        within '.votes' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down', js: true do
      within '.question' do
        click_on 'vote down'
        within '.votes' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  context 'Author can not vote for his question' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'vote up/down' do
      within '.question' do
        within '.votes' do
          expect(page).not_to have_link 'vote up'
          expect(page).not_to have_link 'vote down'
        end
      end
    end
  end

  context 'Unauthenticated user can not vote for any question' do
    before { visit question_path(question) }

    scenario 'vote up/down' do
      expect(page).not_to have_link 'vote up'
      expect(page).not_to have_link 'vote down'
    end
  end
end