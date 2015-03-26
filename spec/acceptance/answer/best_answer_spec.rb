require_relative '../acceptance_helper'

feature 'Choose the best answer', %q{
  In order to show people which answer was helpful
  As an author
  I want to be able to choose the best answer
} do
  given(:author) { create :user }
  given(:another_user) { create :user, :with_answers }
  given!(:question) { create :question, :with_all_the_best_answers, user: author }
  given!(:best_answer) { create :answer, question: question, user: author }

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Best'
  end

  describe 'Author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'sees the best answer link' do
      expect(page).to have_link 'Best'
    end

    scenario 'chooses the best answer', js: true do
      within "#answer-#{best_answer.id}" do
        click_on 'Best'
      end
      expect(page).to have_selector '#best-answer', count: 1
    end

    scenario "can not choose another user's " do
      within "#answer-#{best_answer.id}" do
        expect(page).not_to have_link 'Best'
      end
    end
  end
end