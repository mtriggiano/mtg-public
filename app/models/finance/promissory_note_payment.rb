class PromissoryNotePayment < PromissoryPayment
  belongs_to :old_bank_check, class_name: "PromissoryNotePayment", optional: true, foreign_key: :old_bank_check_id

  has_one :new_bank_check, class_name: "PromissoryNotePayment", foreign_key: :old_bank_check_id

  before_validation :set_numero_pagare

  def payment_type
    "Pagaré"
  end

  def set_numero_pagare
    self.numero_cheque = "Pagaré" if self.numero_cheque.blank?
  end
end
