FactoryGirl.define do
  factory :answer do
    sequence(:body)  { |n| "Answer's body #{n}" }
    question
    user

    trait :with_wrong_attributes do
      body nil
    end

    trait :with_attachments do
      transient do
        number_of_attachments 1
      end

      after(:create) do |answer, evaluator|
        create_list(:attachment, evaluator.number_of_attachments, attachable: answer)
      end
    end
  end
end