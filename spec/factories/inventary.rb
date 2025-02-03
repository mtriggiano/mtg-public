FactoryBot.define do
  factory :product_category do
    company
    name                    { Faker::Commerce.material }
  end

  factory :inventary do
    transient do
      company { nil }
    end
    factory :product, class: "Product", parent: :inventary do
      type { "Product" }
    end
    factory :service, class: "Service", parent: :inventary do
      type { "Service" }
    end
    factory :box, class: "Box", parent: :inventary do
      type { "Box" }
    end
    name                    { Faker::Commerce.product_name }
    code                    { Faker::Number.number(digits: 10).to_s }
    active                  { true }
    measurement             { "1" }
    measurement_unit        { "7" }
    clasification           { "Producto" }
    minimum_stock           { 10.0 }
    available_stock         { 10000.0 }
    product_type            { "regular" }
    traceable               { true }
    gtin                    { "" }
    pm                      { "" }
    family                  { nil }
    recommended_stock       { 100.0 }
    branch                  { "Marca" }
    source                  { "Proveedor" }
    own                     { [false, true].sample }

    before(:create) do |inventary, evaluator|
      category = create(:product_category, company: evaluator.company) if evaluator.company
      inventary.product_category_id = category.id
    end
  end
end
