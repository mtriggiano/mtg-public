class Sales::File < Expedient
  include Numerable
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_many :sale_requests,      class_name: 'Sales::SaleRequest', foreign_key: :file_id, dependent: :destroy
  has_many :budgets,            class_name: 'Sales::Budget',      foreign_key: :file_id, dependent: :destroy
  has_many :orders,             class_name: 'Sales::Order',       foreign_key: :file_id, dependent: :destroy
  has_many :bills,              class_name: 'Sales::Bill',        foreign_key: :file_id, dependent: :destroy
  has_many :shipments,          class_name: 'Sales::Shipment',    foreign_key: :file_id, dependent: :destroy
  has_many :receipts,           class_name: 'Sales::Receipt',     foreign_key: :file_id, dependent: :destroy
  has_many :purchase_requests,  class_name: 'Purchases::PurchaseRequest', foreign_key: :external_file_id
  has_many :responsables,             dependent: :destroy, foreign_key: :file_id
  has_many :file_movements, -> { order(:created_at) }, class_name: 'Sales::FileMovement', dependent: :destroy, foreign_key: :file_id
  has_many :departments, through: :file_movements


  #validate :iva_with_client
  STATES = SUBSTATES + ["En espera de solicitud", "En espera de presupuesto", "En espera de orden de venta",  "En espera de stock", "En espera de salida de stock", "En espera de facturación", "En espera de recibo", "Finalizado"].map(&:upcase)

  ASSOCIATED_STATES = {
    "En espera de solicitud"        => "request",
    "En espera de presupuesto"      => "budget",
    "En espera de orden de compra"  => "order",
    "En espera de facturación"      => "bill",
    "En espera de recibo"           => "receipt"
  }

	TYPES = ["Venta regular", "Venta por mostrador"]

  def destroy
    if (sale_requests.approveds.any? ||
      budgets.approveds.any?           ||
      orders.approveds.any?            ||
      bills.approveds.any?             ||
      shipments.approveds.any?)
        errors.add(:base, "No se puede eliminar expedients con documentos confirmados")
        return false
      else
        self.update_column(:active, false)
    end
  end

  def build_responsables
    assigned_docs = responsables.map{ |resp| resp.document_type}
    ['request', 'budget', 'order', 'bill', 'receipt', 'shipment'].each do |doc|
      responsables.build(document_type: "sale_#{doc}") unless assigned_docs.include?("sale_#{doc}")
    end
    responsables
  end

  def iva_with_client
    if client.iva_cond == "Exento" && !["02", "03"].include?(iva_aliquot)
      errors.add(:iva_aliquot,"El cliente es exento, el expediente no puede tener esta alícuota.")
    end
  end

  def client_name
    client.name
  end

  def initial_department
    read_attribute(:initial_department) || company.departments.select(:id, :name).find_by(name: 'Ventas').try(:id)
  end

  def is_counter_sale?
    sale_type == "Venta por mostrador"
  end

  def set_state
    if sale_requests.empty?
      self.state = "En espera de solicitud"
    elsif budgets.empty?
      self.state = "En espera de presupuesto"
    elsif orders.empty?
      self.state = "En espera de orden de venta"
    elsif purchase_requests.empty?
      self.state = "En espera de stock"
    elsif shipments.empty?
      self.state = "En espera de salida de stock"
    elsif bills.empty?
      self.state = "En espera de facturación"
    elsif receipts.empty?
      self.state = "En espera de recibo"
    else
      self.state = "Finalizado"
    end
    return self.save
  end
end
