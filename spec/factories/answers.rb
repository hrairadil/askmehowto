FactoryGirl.define do
  factory :answers do
    sequence(:body)  { |n| "Answer's body #{n}" }
  end
end