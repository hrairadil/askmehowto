require 'rails_helper'

feature 'Delete answer', %q{
  In order to be able to get rid of unnecessary question
  As an author
  I want to be able to delete question
} do
  given!(:author) { create :user, :with_questions }
  given!(:another_user) { create :user, :with_questions }


  scenario 'Author tries to delete his question' do
    sign_in(author)
    visit question_path(author.questions.first)
    click_on 'Delete question'
    expect(page).to have_content 'Question has been successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'Author tries to delete another users question'
  scenario 'Guest tries to delete a question'
end