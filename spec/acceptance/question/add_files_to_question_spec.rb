require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body'
    attach_file 'File', "#{Rails.root}/spec/fixtures/screenshot0.jpg"
    click_on 'Create'

    expect(page).to have_link 'screenshot0.jpg', href: '/uploads/attachment/file/1/screenshot0.jpg'
  end

  scenario 'User sees link "Add more"' do
    expect(page).to have_link "Add more"
  end

  scenario 'User adds several files when asks question', js: true do
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body'

    click_on 'Add more'
    inputs = all('input[type="file"]')
    2.times { |i| inputs[i].set("#{Rails.root}/spec/fixtures/screenshot#{i}.jpg") }
    click_on 'Create'

    2.times { |i| expect(page).to have_link "screenshot#{i}.jpg" }
  end
end