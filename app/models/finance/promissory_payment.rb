class PromissoryPayment < ApplicationRecord
  belongs_to :client, foreign_key: :entity_id
  belongs_to :company
  belongs_to :receipt, class_name: "Sales::Receipt", optional: true

  validates_presence_of :concepto, :importe, :vencimiento, :numero_cheque

  scope :pendientes, -> { where(importe_cobrado: nil) }
  scope :daily, ->(fecha) { where(vencimiento: fecha) }
  
  def cobrado?
    !importe_cobrado.nil?
  end

  def self.search data
    return all if data.blank?
    includes(:client, :receipt).references(:client, :receipt).where("
      receipts.number ILIKE :data OR
      LOWER(entities.name) LIKE :data OR
      importe::text LIKE :data OR
      numero_cheque LIKE :data
    ", data: "%#{data.downcase}%")

  end

  def estado
    return "En cartera" unless cobrado?
    "Depositado"
  end

  def payment_type
    rais NotImplementedError unless defined?(super)
  end

  def dias_restantes(fecha = Date.today)
    fecha ||= Date.today
    diff = (self.vencimiento - fecha.to_date).to_i
    return diff
  end

  # utilizado para registrar un cambio de cheque
  def posible_cambio?
    !cobrado?
  end

  # al registrar el cambio de un cheque debemos marcar el anterior para que no figure en cartera
  # la cartera de cheques no debe mostrar cheques con importe_cobrado != nil
  def cheque_reemplazado!
    update_columns(
      importe_cobrado: 0,
      fecha_deposito: Date.today
    )
  end

  def cheque_reemplazado?
    old_bank_check.present?
  end
end
