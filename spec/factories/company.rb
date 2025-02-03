FactoryBot.define do
  factory :company do
    name                        { Faker::Company.name }
    society_name                { "#{name} S.A." }
    code                        { Faker::Number.number(digits: 6) }
    email                       { Faker::Internet.email }
    logo                        { Faker::Avatar.image(slug: "my-own-slug", size: "50x50") }
    address                     { "Dirección..." }
    cuit                        { Faker::Number.number(digits: 11) }
    concept                     { "01" }
    currency                    { "PES" }
    iva_cond                    { "Responsable Inscripto" }
    postal_code                 { "4400" }
    activity_init_date          { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    contact_number              { nil }
    environment                 { "test" }
    cbu                         { Faker::Number.number(digits: 22).to_s }
    paid                        { false }
    suscription_type            { nil }
    active                      { true }
    coefficient_for_net_amount  { 0.74 }
    anmat_user                  { nil }
    anmat_password              { nil }
    gln                         { nil }
    anmat_type                  { nil }
    pdf_logo                    { nil }
    gross_income                { "" }
  end
end
