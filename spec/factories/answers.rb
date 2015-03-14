FactoryGirl.define do
  factory :answer do
    sequence(:body)  { |n| "Answer's body #{n}" }
    question

    trait :with_wrong_attributes do
      body nil
    end
  end
end