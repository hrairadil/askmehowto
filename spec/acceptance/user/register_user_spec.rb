require 'rails_helper'

feature 'User registration', %q{
  In order to be able to ask question
  As an user
  I want to be able to register
} do
  scenario 'Non-existed user tries to register'
  scenario 'Existed user tries to register'
end