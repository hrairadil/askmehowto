require 'rails_helper'

feature 'User browses a list of questions', %q{
  In order to be able to browse created questions
  as a guest
  I want to be able to see a list of existing questions
} do

  given(:questions){ create_list(:question, 2) }

  scenario 'Guest tries to browse a list of questions' do
    visit questions_path(questions)
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[1].body
  end
end