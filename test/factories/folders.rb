FactoryBot.define do
  factory :folder do
    association :office
    name { "MyString" }
    path { "MyText" }
  end
end
