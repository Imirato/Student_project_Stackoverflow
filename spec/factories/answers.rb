FactoryBot.define do
  factory :answer do
    association :question
    association :user
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
