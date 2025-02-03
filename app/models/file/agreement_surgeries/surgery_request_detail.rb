class AgreementSurgeries::SurgeryRequestDetail < ApplicationRecord
  belongs_to :surgery_request

   TABLE_COLUMNS = {
    "Número" => {"important" => false,  "fixed" => false},
    "⚫" => {"important" => false,  "fixed" => false},
    'Producto' => { 'important' => true,  'fixed' => false },
    'Código de producto' => { 'important' => false, 'fixed' => false },
    'Cantidad' => { 'important' => true,  'fixed' => false },
  }

  validates :quantity, presence: false
  validates :surgery_material, presence: true
  
  

end
