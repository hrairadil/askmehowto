FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title ##{n}" }
    sequence(:body)  { |n| "Body ##{n}" }

    trait :with_answers do
      transient do
        number_of_answers 10
      end

      after(:build) do |question, evaluator|
        create_list(:answer, evaluator.number_of_answers, question: question)
      end
    end
  end
end