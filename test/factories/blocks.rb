FactoryBot.define do
  factory :block do
    association :project
    name { "MyString" }
    path { "MyText" }
  end
end
