FactoryBot.define do
  factory :bank_account_movement do
    transaction { nil }
    due_date { "2020-12-13" }
    emision { "2020-12-13" }
    doc_type { 1 }
    bank_account { nil }
    supplier { nil }
    state { 1 }
    observation { "MyString" }
    total { "9.99" }
    payments { "MyString" }
    balance { "9.99" }
  end
end
