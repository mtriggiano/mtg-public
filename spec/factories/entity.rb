FactoryBot.define do
  factory :client do
    company
    name                { Faker::Company.name }
    address             { Faker::Address.street_address }
    document_type       { "80" }
    document_number     { Faker::Number.number(digits: 8) }
    active              { true }
    iva_cond            { ["Responsable Inscripto", "Responsable Monotributo", "Exento", "Consumidor final"].sample }
    recharge            { 0.0 }
    current_balance     { 0 }
    gln                 { "" }
    bank                { nil }
    account             { nil }
    cbu                 { nil }
    subtype             { "public_administration" }
    sector              { nil }
    denomination        { name }
    payment_days        { 30 }
    cp                  { "4400" }
  end


  factory :supplier do
    company
    name                { Faker::Company.name }
    address             { Faker::Address.street_address }
    document_type       { "80" }
    document_number     { Faker::Number.number(digits: 8) }
    active              { true }
    iva_cond            { ["Responsable Inscripto", "Responsable Monotributo", "Exento", "Consumidor final"].sample }
    recharge            { 0.0 }
    current_balance     { 0 }
    gln                 { "" }
    bank                { nil }
    account             { nil }
    cbu                 { nil }
    subtype             { "public_administration" }
    sector              { ["Público", "Privado"].sample }
    denomination        { name }
    payment_days        { 30 }
    cp                  { "4400" }
  end
end
