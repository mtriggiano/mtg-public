FactoryBot.define do
  factory :expedient do
    association :company
    association :user
    current_user          { user }
    sale_type             { "Venta regular" }
    init_date             { Date.today }
    open                  { true }
    active                { true }
    finish_date           { Date.today + 1.week }
    iva_aliquot           { "05" }
    custom_attributes     { {"place"=>"", "detail"=>"Traumatología", "doctor"=>"Doctor", "pacient"=>"Paciente", "province"=>"", "pacient_number"=>"", "external_number"=>"", "external_shipment_number"=>"", "external_purchase_order_number"=>""} }
    surgery_end_date      { Date.today + 5.days }
    substate              { "COTIZADO" }
    need_surgical_sheet   { [true, false].sample }
    need_implant          { [true, false].sample }
    need_note             { [true, false].sample }
    need_sticker          { [true, false].sample }
    
    factory :surgery_file, class: "Surgeries::File", parent: :expedient do
      association :entity, factory: :client
      type   { "Surgeries::File" }
      title  { "Cx #{entity.name}" }
      state  { Surgeries::File::STATES.sample }
      number { (company.surgery_files.last.try(:number).to_f + 1).to_s.rjust(8, '0') }
    end

    factory :sale_file, class: "Sales::File", parent: :expedient do
      association :entity, factory: :client
      type   { "Sales::File" }
      title  { "Venta #{entity.name}" }
      state  { Sales::File::STATES.sample }
      number { (company.sale_files.last.try(:number).to_f + 1).to_s.rjust(8, '0') }
    end

    factory :purchase_file, class: "Purchases::File", parent: :expedient do
      type   { "Purchases::File" }
      title  { "Compra #{entity.name}" }
      state  { Purchases::File::STATES.sample }
      number { (company.purchase_files.last.try(:number).to_f + 1).to_s.rjust(8, '0') }
    end

  end

end
