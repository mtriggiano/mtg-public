FactoryBot.define do
  factory :comment do
    articleable { nil }
    user { nil }
    body { "MyString" }
    seen { false }
    seen_at { "2020-08-02 08:54:27" }
  end
end
