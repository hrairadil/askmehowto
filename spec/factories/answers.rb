FactoryGirl.define do
  factory :answer do
    sequence(:body)  { |n| "Answer's body #{n}" }
    question
  end
end