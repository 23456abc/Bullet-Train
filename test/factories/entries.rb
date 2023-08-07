FactoryBot.define do
  factory :entry do
    association :team
    entryable { nil }
  end
end
