require 'rails_helper'

feature 'User browses a list of questions', %q{
  In order to be able to browse created questions
  as a guest
  I want to be able to see a list of existing questions
} do

  given(:questions){ create_list(:question, 5) }

  scenario 'Guest tries to browse a list of questions' do
    visit questions_path(questions)
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end