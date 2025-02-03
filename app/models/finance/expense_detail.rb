# Autor: Ariel Agustín García Sobrado
# Representa: Gastos (de todo tipo) que puede tener la empresa.
# Contiene la info del tipo de gasto y es utilizado para calcular IVA compras.
#
# Consideraciones: STI (columna type)
#
# Encontrado en:
#   - Gastos de Solicitudes de fondos - ExpenditureDetail
#   - Gastos de Caja - CashAccountExpenditure
#   - Gastos Extraordinarios - Expenditure
#
class ExpenseDetail < ApplicationRecord
  belongs_to :order, class_name: "ExpedientOrder", foreign_key: :order_id, optional: true
  belongs_to :supplier, class_name: "Supplier", foreign_key: :entity_id, optional: true
  belongs_to :disable_user, class_name: "User", foreign_key: :disable_user_id, optional: true

  COMP_TYPES = %w(A B C T SC) # TIPOS DE COMPROBANTES

  before_validation :establece_nombre_proveedor
  validates_presence_of :fecha
  validates :letra,
    presence: true,
    inclusion: COMP_TYPES
  validates_presence_of :descripcion
  validates_presence_of :supplier_name, message: "Seleccione o ingrese el nombre del proveedor"
  validates_presence_of :total
  validate :comprobante
  after_validation :completa_campos_comprobante

  scope :activos, -> { where(disabled_time: nil) }
  scope :contable, -> { where(letra: "A", disabled_time: nil) }
  scope :daily, ->(fecha) { where(fecha: fecha) }
  scope :unarchived, -> {where(archived: false)}

  def codigo_comprobante
    return "#{self.letra}-#{self.punto_venta}-#{self.num_comprobante}" if comprobante_oficial?
    return self.letra
  end

  def active?
    disabled_time == nil
  end

  def fecha_registro
    super() || Date.today
  end


  private

  def comprobante
    if comprobante_oficial?
      errors.add(:base, "Debe ingresar el punto de venta para comprobantes tipo #{self.letra}") if punto_venta.blank?
      errors.add(:base, "Debe ingresar el número para comprobantes tipo #{self.letra}") if num_comprobante.blank?
      errors.add(:base, "Debes vincular un proveedor para comprobantes tipo #{self.letra}") if supplier.blank?
      #errors.add(:base, "Debes indicar la fecha de registro para comprobantes tipo #{self.letra}") if fecha_registro.blank?
    end
  end

  def completa_campos_comprobante
    self.punto_venta     = self.punto_venta.rjust(4, "0") unless self.punto_venta.blank?
    self.num_comprobante = self.num_comprobante.rjust(8, "0") unless self.num_comprobante.blank?
  end

  def establece_nombre_proveedor
    self.supplier_name = self.supplier.name if self.entity_id
  end

  def comprobante_oficial?
    %w(A C).include?(self.letra)
  end
end
