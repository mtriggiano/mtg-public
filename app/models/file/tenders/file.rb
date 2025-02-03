class Tenders::File < Expedient
  include Numerable
  include HasAttachments
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity


  has_many :sale_requests,           class_name: 'Tenders::SaleRequest',     foreign_key: :file_id, dependent: :destroy
  has_many :supplier_budgets,   class_name: "Tenders::SupplierBudget", foreign_key: :file_id, dependent: :destroy
  has_many :budgets,            class_name: 'Tenders::Budget',      foreign_key: :file_id, dependent: :destroy
  has_many :orders,             class_name: 'Tenders::Order',       foreign_key: :file_id, dependent: :destroy
  has_many :bills,              class_name: 'Tenders::Bill',        foreign_key: :file_id, dependent: :destroy
  has_many :shipments,          class_name: 'Tenders::Shipment',    foreign_key: :file_id, dependent: :destroy
  has_many :purchase_requests,  class_name: 'Purchases::PurchaseRequest', foreign_key: :external_file_id
  has_many :budget_attachments, class_name: 'Tenders::BudgetAttachment', foreign_key: :file_id, dependent: :destroy, source: :expedient
  has_many :responsables,       dependent: :destroy, foreign_key: :file_id
  has_many :file_movements, -> { order(:created_at) }, class_name: 'Tenders::FileMovement', dependent: :destroy, foreign_key: :file_id
  has_many :departments, through: :file_movements

  store_accessor :custom_attributes,
  :pacient,
  :pacient_number,
  :doctor,
  :place,
  :date,
  :shipping,
  :generated_by_system,
  :attachement,
  :procediment,
  :destinos,
  :objeto,
  :open_date,
  :open_hs,
  :resolution,
  :forma_pago,
  :recepcion_sobres_lugar,
  :reception,
  :sistema_apertura,
  :precio_pliego

  accepts_nested_attributes_for :budget_attachments, reject_if: :all_blank, allow_destroy: true

  STATES = SUBSTATES + ["En espera de presupuesto", "En espera de orden de venta",  "En espera de stock", "En espera de salida de stock", "En espera de facturación", "En espera de recibo", "Finalizado"].map(&:upcase)

  ASSOCIATED_STATES = {
    "En espera de presupuesto"      => "budget",
    "En espera de orden de compra"  => "order",
    "En espera de facturación"      => "bill",
    "En espera de recibo"           => "receipt"
  }

	TYPES = ["Ventas", "CX"]

  def destroy
    if budgets.approveds.any? ||
       orders.approveds.any? ||
       bills.approveds.any? ||
       shipments.approveds.any?
        errors.add(:base, "No se puede eliminar expedients con documentos confirmados")
        return false
      else
        self.update_column(:active, false)
    end
  end

  def build_responsables
    assigned_docs = responsables.map{ |resp| resp.document_type}
    ['budget', 'order', 'bill', 'receipt', 'shipment'].each do |doc|
      responsables.build(document_type: "tender_#{doc}") unless assigned_docs.include?("tender_#{doc}")
    end
    responsables
  end

  def client_name
    client.name
  end

  def initial_department
    read_attribute(:initial_department) || company.departments.select(:id, :name).find_by(name: 'Ventas').try(:id)
  end

  def is_counter_tender?
    sale_type == "Venta por mostrador"
  end

  def set_state
    if budgets.empty?
      self.state = "En espera de presupuesto"
    elsif orders.empty?
      self.state = "En espera de orden de venta"
    elsif purchase_requests.empty?
      self.state = "En espera de stock"
    elsif shipments.empty?
      self.state = "En espera de salida de stock"
    elsif bills.empty?
      self.state = "En espera de facturación"
    else
      self.state = "Finalizado"
    end
    return self.save
  end
end
