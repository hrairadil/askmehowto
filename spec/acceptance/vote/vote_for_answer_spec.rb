require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to choose the best solution
  As an authenticated user
  I'd like to have an opportunity to vote for answer
} do
  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up', js: true do
      within '.answers' do
        click_on 'up'
        within '.votes' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down', js: true do
      within '.answers' do
        click_on 'down'
        expect(page).to have_conten '-1'
      end
    end
  end
end