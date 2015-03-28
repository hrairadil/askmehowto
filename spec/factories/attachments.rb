FactoryGirl.define do
  factory :attachment do
    file "#{Rails.root}/spec/acceptance/fixtures/screenshot.jpg"
  end
end
