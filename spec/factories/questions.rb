FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title ##{n}" }
    sequence(:body)  { |n| "Body ##{n}" }
    user

    trait :with_answers do
      transient do
        number_of_answers 4
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.number_of_answers, question: question)
      end
    end

    trait :with_wrong_attributes do
      title nil
      body nil
    end
  end
end