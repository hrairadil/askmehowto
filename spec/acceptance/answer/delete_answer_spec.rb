require 'rails_helper'

feature 'Delete question', %q{
  In order to be able to get rid of unnecessary question
  As an author
  I want to be able to delete question
} do
  scenario 'Author tries to delete his question'
  scenario 'Author tries to delete another users question'
  scenario 'Guest tries to delete an question'
end