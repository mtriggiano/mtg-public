FactoryBot.define do
  factory :expedient_order do

    factory :purchase_order, class: "Purchases::Order", parent: :expedient_order do
      type { "Purchases::Order" }
      association :file, factory: :purchase_file
    end
    factory :sale_order, class: "Sale::Order", parent: :expedient_order do
      type { "Sale::Order" }
      association :file, factory: :sale_file
    end
    factory :surgery_sale_order, class: "Surgeries::SaleOrder", parent: :expedient_order do
      type { "Surgeries::SaleOrder" }
      association :file, factory: :surgery_file
    end
    factory :surgery_purchase_order, class: "Surgeries::PurchaseOrder", parent: :expedient_order do
      type { "Surgeries::PurchaseOrder" }
      association :file, factory: :surgery_file
    end

    association :company
    association :user
    association :entity, factory: :supplier

    number                      { Faker::Number.number(digits: 8).to_s }
    state                       { ExpedientOrder::STATES.sample }
    active                      { true }
    observation                 { "" }
    subtotal                    { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    discount                    { 0 }
    total                       { subtotal }
    paid                        { false }
    total_pay                   { 0 }
    total_left                  { total }
    delivered                   { false }
    expected_delivery_date      { Date.today + 5.days }
    order_type                  { "Venta regular" }
    shipping_price              { 0 }
    shipping_included           { false }
    total_usd                   { 0 }
    usd_price                   { 0 }
    currency                    { "ARS" }
    type                        { nil }

    after(:build) do |order, evaluator|
      d = build(:expedient_order_detail, order: order)
      evaluator.current_user = order.user
      evaluator.details.first.attributes = d.attributes
    end
  end

  factory :expedient_order_detail do
    association :order
    association :inventary, factory: :product
    active                { true }
    product_name          { inventary.name }
    product_code          { inventary.code }
    quantity              { Faker::Number.between(from: 1, to: 10) }
    price                 { 100 }
    discount              { 0 }
    total                 { 121 }
    product_measurement   { "Unidad" }
    detail_type           { "Consumo" }
    iva_aliquot           { "05" }
    delivered             { false }
    has_stock             { nil }
    billed                { false }
    description           { nil }
    user_id               { nil }
    custom_attributes     { nil }
    custom_detail         { false }
    order_detail_id       { nil }
    base_offer            { false }
    tipo                  { nil }
    branch                { nil }
    source                { nil }
  end
end
