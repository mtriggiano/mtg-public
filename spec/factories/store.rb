FactoryBot.define do
  factory :store do
    association :company
    name    { Faker::Company.name }
    location { "Central" }
  end
end
