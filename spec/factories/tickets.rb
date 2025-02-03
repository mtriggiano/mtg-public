FactoryBot.define do
  factory :ticket do
    title { "MyString" }
    body { "MyText" }
    priority { 1 }
    function_points { 1 }
    init_date { "2020-08-02" }
    finish_date { "2020-08-02" }
    file { "MyString" }
    state { "MyString" }
    state_changed_by { "" }
    company { nil }
    user { nil }
  end
end
