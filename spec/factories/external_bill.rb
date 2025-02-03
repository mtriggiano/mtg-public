FactoryBot.define do
  factory :external_bill do
    company
    association :entity,  factory: :supplier, company: company
    association :user,    company: company
    active                { true }
    state                 { ExternalBIll::STATES.sample }
    total                 { 1210 }
    total_pay             { 0.0 }
    total_left            { 1210 }
    sale_point            { "0009" }
    cbte_tipo             { "01" }
    concept               { "Productos" }
    cbte_fch              { Date.today.to_s }
    iva_cond              { "Responsable Inscripto" }
    number                { Faker::Number.digits(8).to_s }
    fch_vto_pago          { Date.today }
    expired               { false }
    type                  { "ExternalBill" }
    flow                  { "discharge" }
    gross_amount          { 1000 }
    iva_amount            { 210.0 }
    due_date              { Date.today }
    total_trib            { 0.0 }
    registration_date     { Date.today }
    total_usd             { 0.709e1 }
    usd_price             { 0.705e2 }
    currency              { "ARS" }
    manual                { "E" }
    canceled              { false }

    after(:build) do |bill|
      build(:external_bill_detail, external_bill: bill, company: company)
    end
  end

  factory :external_bill_detail do
    external_bill
    transient do
      company { nil }
    end
    association :inventary, :product, company: company
    quantity                  { 2.0 }
    product_name              { product.name }
    product_measurement       { "Unidad" }
    price                     { 500.0 }
    discount                  { 0.0 }
    bonus_amount              { 0.0 }
    total                     { 1210.0 }
    iva_aliquot               { "05" }
    iva_amount                { 120.0 }
    active                    { true }
    neto                      { 0.5e3 }

    trait :product do
      subtype { "BillInventary" }
    end
    trait :service do
      subtype { "BillService" }
    end
  end
end
