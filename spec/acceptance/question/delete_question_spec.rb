require_relative '../acceptance_helper'

feature 'Delete question', %q{
  In order to be able to get rid of unnecessary question
  As an author
  I want to be able to delete question
} do
  given(:author) { create :user, :with_questions }
  given(:another_user) { create :user, :with_questions }


  scenario 'Author tries to delete his own question' do
    sign_in(author)
    visit question_path(author.questions.first)
    click_on 'Delete question'
    expect(page).to have_content 'Question has been successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'Author tries to delete another users question' do
    sign_in(author)
    visit question_path(another_user.questions.first)
    expect(page).not_to have_link 'Delete question'
  end

  scenario 'Guest tries to delete a question' do
    visit question_path(author.questions.first)
    expect(page).not_to have_link 'Delete question'
  end
end