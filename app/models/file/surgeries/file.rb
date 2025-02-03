class Surgeries::File < Expedient
  include Numerable
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_many :prescriptions,      class_name: 'Surgeries::Prescription',    foreign_key: :file_id, dependent: :destroy
  has_many :budgets,            class_name: 'Surgeries::Budget',          foreign_key: :file_id, dependent: :destroy
  has_many :sale_orders,        class_name: 'Surgeries::SaleOrder',       foreign_key: :file_id, dependent: :destroy, inverse_of: :file
  has_many :purchase_orders,    class_name: 'Surgeries::PurchaseOrder',   foreign_key: :file_id, dependent: :destroy
  has_many :purchase_requests,  class_name: 'Surgeries::PurchaseRequest', foreign_key: :file_id, dependent: :destroy
  has_many :supplier_requests,  class_name: 'Surgeries::SupplierRequest', foreign_key: :file_id, dependent: :destroy
  has_many :shipments,          class_name: 'Surgeries::Shipment',        foreign_key: :file_id, dependent: :destroy
  has_many :consumptions,       class_name: 'Surgeries::Consumption',     foreign_key: :file_id, dependent: :destroy
  has_many :devolutions,        class_name: 'Surgeries::Devolution',      foreign_key: :file_id, dependent: :destroy
  has_many :client_bills,       class_name: 'Surgeries::ClientBill',      foreign_key: :file_id, dependent: :destroy, inverse_of: :file
  has_many :receipts,           class_name: 'Surgeries::Receipt',         foreign_key: :file_id, dependent: :destroy
  has_many :file_movements,     class_name: 'Surgeries::FileMovement',    foreign_key: :file_id, dependent: :destroy
  has_many :suppliers, through: :purchase_orders
  has_many :cx_notificacions, as: :fileable, class_name: 'CxNotification'

  # usado para modificar el vendedor de las ordenes de venta
  attr_accessor :seller_id_temp

  #has_many :supplier_bills,     ->{joins([{arrivals: :supplier_bills}, {purchase_orders: :supplier_bills}])}

  validates_presence_of :number, message: "Debe especificar"

  STATES = SUBSTATES + [
    'En espera de receta',
    'En espera de cotización',
    'En espera de orden de venta',
    'En espera de presupuesto de proveedor',
    'En espera de llegada de stock',
    'En espera de salida de stock',
    'En espera de registro de consumo',
    'En espera de orden de compra',
    'En espera de facturación',
    'Finalizado'].map(&:upcase)

  ASSOCIATED_STATES = {
    'En espera de receta' => 'request',
    'En espera de orden de compra' => 'order',
    'En espera de remito' => 'shipment'
  }.freeze

  TYPES = ['Cirugía'].freeze

  def destroy
    if prescriptions.approveds.any? ||
       budgets.approveds.any? ||
       sale_orders.approveds.any? ||
       purchase_orders.approveds.any? ||
       purchase_requests.approveds.any? ||
       supplier_requests.approveds.any? ||
       shipments.approveds.any? ||
       consumptions.approveds.any? ||
       devolutions.approveds.any? ||
       client_bills.approveds.any?
        errors.add(:base, "No se puede eliminar expedients con documentos confirmados")
        return false
      else
        self.update_column(:active, false)
    end
  end

  def build_responsables
    assigned_docs = responsables.map(&:document_type)
    %w[prescription budget sale_order request consumption order shipment arrival client_bill supplier_bill].each do |doc|
      unless assigned_docs.include?("surgery_#{doc}")
        responsables.build(document_type: "surgery_#{doc}")
        end
    end
    responsables
  end

  def supplier_bills
    company.external_bills
      .joins(
        "LEFT JOIN bills_orders ON bills_orders.bill_id = bills.id
        LEFT JOIN orders ON orders.id = bills_orders.order_id"
      ).where("orders.file_id = :file_id", file_id: id).distinct
  end

  def arrivals
    company.external_arrivals
      .joins(
        "LEFT JOIN arrivals_requests ON arrivals_requests.arrival_id = arrivals.id
        LEFT JOIN requests ON requests.id = arrivals_requests.request_id
        LEFT JOIN arrivals_orders ON arrivals_orders.arrival_id = arrivals.id
        LEFT JOIN orders ON orders.id = arrivals_orders.order_id"
      ).where("requests.file_id = :file_id OR orders.file_id = :file_id", file_id: id).distinct
  end
  alias_method :external_arrivals, :arrivals

  def initial_department
    read_attribute(:initial_department) || company.departments.select(:id, :name).find_by(name: 'Ventas').try(:id)
  end

  def set_state
    if prescriptions.empty?
      self.state = "En espera de receta"
      elsif budgets.empty?
      self.state = "En espera de cotización"
      elsif sale_orders.empty?
      self.state = "En espera de orden de venta"
      elsif purchase_requests.empty?
      self.state = "En espera de presupuesto de proveedor"
      elsif arrivals.empty?
      self.state = "En espera de llegada de stock"
      elsif shipments.empty?
      self.state = "En espera de salida de stock"
      elsif consumptions.empty?
      self.state = "En espera de registro de consumo"
      elsif purchase_orders.empty?
      self.state = "En espera de orden de compra"
      elsif arrivals.empty?
      self.state = "En espera de llegada de stock"
      elsif client_bills.empty?
      self.state = "En espera de facturación"
      else
      self.state = "Finalizado"
    end
    return self.save
  end

  def pacient_with_number
    "#{pacient} Nº#{pacient_number}"
  end

  def start_time
    surgery_end_date
  end
end
