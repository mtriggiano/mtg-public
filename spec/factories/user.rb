FactoryBot.define do
  factory :user do
    company
    first_name          { "Facundo" }
    last_name           { "Diaz Martinez" }
    document_type       { "80" }
    document_number     { Faker::Number.number(digits: 6) }
    birthday            { nil }
    address             { "" }
    postal_code         { "" }
    active              { true }
    avatar              { "https://s3.sa-east-1.amazonaws.com/litecode.factur..." }
    phone               { "" }
    mobile_phone        { "" }
    approved            { true }
    company_owner       { true }
    admin               { false }
    email               { Faker::Internet.email }
    password            { "123456" }
    locality_id         { nil }
    store_id            { nil }
    machine_id          { Faker::Number.number(digits: 3).to_s }
    status              { "Activo" }
    start_of_activity   { nil }
    contract            { nil }
    talliable           { true }
    position            { nil }
    work_station_id     { nil }
    file_number         { nil }
  end
end
