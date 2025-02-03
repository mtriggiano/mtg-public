FactoryBot.define do
  factory :shipment_arrival do
    shipment { nil }
    arrival { nil }
    active { false }
  end
end
