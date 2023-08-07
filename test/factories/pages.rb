FactoryBot.define do
  factory :page do
    association :site
    name { "MyString" }
    path { "MyText" }
  end
end
