FactoryBot.define do
  factory :site do
    association :team
    name { "MyString" }
    sort_order { 1 }
  end
end
