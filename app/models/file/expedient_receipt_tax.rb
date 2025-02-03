class ExpedientReceiptTax < ApplicationRecord
  belongs_to :receipt, class_name: "ExpedientReceipt", inverse_of: :taxes, foreign_key: :receipt_id

  validates_presence_of :total, message: "Debe especificar el total"
  validates_presence_of :tax_type, message: "Tipo inválido"
  validates :total, numericality: {min: 0, message: "El valor mìnimo es 0"}

end
