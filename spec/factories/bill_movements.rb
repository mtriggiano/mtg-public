FactoryBot.define do
  factory :bill_movement do
    bill { nil }
    date { "2020-06-19" }
    bill_name { "MyString" }
    client { "MyString" }
    delivered_to { "MyString" }
    signed { false }
    returned { false }
    observation { "MyText" }
  end
end
