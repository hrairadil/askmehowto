require 'rails_helper'

feature 'Delete answer', %q{
  In order to be able to get rid of unnecessary answer
  As an author
  I want to be able to delete answer
} do
  scenario 'Author tries to delete his answer'
  scenario 'Author tries to delete another users answer'
  scenario 'Guest tries to delete an answer'
end