require_relative '../acceptance_helper'

feature 'Remove files from answer', %q{
  In order to get rid of unnecessary attachments
  As an author of a question
  I'd like to be able to remove files from the answer
} do

  scenario 'Author sees remove link'
  scenario 'Author removes files'
  scenario "Author can not remove another user's files"
end