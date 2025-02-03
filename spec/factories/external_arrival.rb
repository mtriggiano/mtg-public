FactoryBot.define do
  factory :external_arrival do
    association :company
    association :entity,  factory: :supplier
    association :user
    active                { true }
    state                 { ExternalArrival::STATES.sample }
    store_id              { company.stores.first&.id }
    date                  { Date.today }
    number                { Faker::Number.number(digits: 8).to_s }
    transient do
      product { product }
    end
    after(:build) do |arrival, options|
      arrival.details << build(:external_arrival_detail, product: options.product || create(:product, company: arrival.company))
      arrival.entity ||= create(:supplier, company: arrival.company)
      arrival.user ||= create(:user, company: arrival.company)
      arrival.store ||= create(:store, company: arrival.company)
      arrival.current_user = arrival.user
      arrival.details.each do |detail|
        detail.mark_for_destruction if detail.product_id.nil?
      end
    end
  end

  factory :external_arrival_detail do
    trait :product do
      product
    end
    product_id                { product.id}
    product_name              { product.name }
    requested_quantity        { 1.0 }
    quantity                  { requested_quantity }
    product_code              { product.code }
  end
end
