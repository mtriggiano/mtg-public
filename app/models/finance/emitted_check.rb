class EmittedCheck < ApplicationRecord
  belongs_to :supplier, foreign_key: 'entity_id'
  belongs_to :company
  belongs_to :payment_order, class_name: 'Purchases::PaymentOrder', optional: true
  belongs_to :checkbook, optional: true

  belongs_to :bank_account, optional: true

  has_many :check_amends

  accepts_nested_attributes_for :check_amends, reject_if: :all_blank, allow_destroy: true

  ESTADOS = %W(Pendiente Anulado Pagado)

  before_save :get_check_number, :calculate_saldo, :set_estado
  before_create :set_pendiente
  before_save :set_bank_account

  validates_presence_of :importe, :numero
  validates_uniqueness_of :numero, scope: :checkbook_id, message: "El número de cheque ya fue registrado", unless: :cheque_electronico?
  #validates_uniqueness_of :numero, scope: :check_type, message: "El número de cheque electronico ya fue registrado", if: :cheque_electronico?
  #validate :check_number, if: :cheque_electronico?
  scope :pendientes, -> { where(estado: "Pendiente") }

  def get_check_number
    # self.numero = self.checkbook.get_next_number
  end

  def cheque_electronico?
    check_type == "Cheque electrónico"
  end

  def set_bank_account
    if bank_account_id.nil?
      unless checkbook.nil?
        self.bank_account_id = self.checkbook.try(:bank_account_id)
      end
    end
  end

  def calculate_saldo
    self.saldo = self.importe - self.importe_pagado
  end

  def set_estado
    self.estado = "Pagado" if saldo == 0
  end

  def set_pendiente
    self.estado = "Pendiente"
  end

  def dias_restantes(fecha = Date.today)
    fecha ||= Date.today
    diff = (self.vencimiento - fecha.to_date).to_i
    return diff
  end

  def check_number
    if check_type == "Cheque electrónico"
      unless EmittedCheck.where(number: self.numero, check_type: "Cheque electrónico").blank?
        errors.add(:numero, "El número de cheque electrónico ya existe")
      end
    end
  end

  def self.set_bank_account
    checks = where.not(checkbook_id: nil)
    checks.each do |check|
      unless check.checkbook.nil?
        check.update_columns(bank_account_id: check.checkbook.bank_account_id)
      end
    end
  end
end
