class Purchases::File < Expedient

	include Numerable

	STATES = ["En espera de solicitud", "En espera de presupuesto", "En espera de orden de compra", "En espera de remito", "En espera de pago a proveedor", "Pagado", "En espera de pago", "Finalizado"]

  ASSOCIATED_STATES = {
    "En espera de solicitud"        => "request",
    "En espera de presupuesto"      => "budget",
    "En espera de orden de compra"  => "order",
    "En espera de facturación"      => "invoice",
    "En espera de remito"           => "arrival"
  }


	has_many :budgets, class_name: "Purchases::Budget", foreign_key: :file_id, dependent: :destroy
	has_many :purchase_orders, class_name: "Purchases::PurchaseOrder", foreign_key: :file_id, dependent: :destroy
	has_many :purchase_requests, class_name: "Purchases::PurchaseRequest", foreign_key: :file_id, dependent: :destroy
	#has_many :arrivals, class_name: "Purchases::Arrival", foreign_key: :file_id, dependent: :destroy
	has_many :shipments, class_name: "Purchases::Shipment", foreign_key: :file_id, dependent: :destroy
	has_many :consumptions, class_name: "Purchases::Consumption", foreign_key: :file_id, dependent: :destroy
	#has_many :bills, class_name: "Purchases::Bill", foreign_key: :file_id, dependent: :destroy
	has_many :orders, class_name: "Purchases::Order", foreign_key: :file_id, dependent: :destroy
	has_many :devolutions, class_name: "Purchases::Devolution", foreign_key: :file_id, dependent: :destroy
	has_many :file_movements, class_name: 'Purchases::FileMovement', dependent: :destroy, foreign_key: :file_id
	has_many :departments, through: :file_movements
	validates_inclusion_of  :state, in: STATES, message: "Estado inválido"

	after_create :set_first_movement
  after_touch :set_state


  def build_responsables
    assigned_docs = responsables.map{ |resp| resp.document_type}
    ['request', 'budget', 'order', 'invoice', 'shipment'].each do |doc|
      responsables.build(document_type: "purchase_#{doc}") unless assigned_docs.include?("purchase_#{doc}")
    end
    return responsables
  end

	def destroy
    if purchase_requests.approveds.any? ||
       budgets.approveds.any? ||
       bills.approveds.any? ||
       orders.approveds.any? ||
			 devolutions.approveds.any?
        errors.add(:base, "No se puede eliminar expedients con documentos confirmados")
        return false
      else
        self.update_column(:active, false)
    end
  end

  def bills
    company.external_bills
      .joins(
        "LEFT JOIN bills_orders ON bills_orders.bill_id = bills.id
        LEFT JOIN orders ON orders.id = bills_orders.order_id"
      ).where("orders.file_id = :file_id", file_id: id).distinct
  end
  alias_method :supplier_bills, :bills

	def arrivals
    company.external_arrivals
      .joins(
        "LEFT JOIN arrivals_requests ON arrivals_requests.arrival_id = arrivals.id
        LEFT JOIN requests ON requests.id = arrivals_requests.request_id
        LEFT JOIN arrivals_orders ON arrivals_orders.arrival_id = arrivals.id
        LEFT JOIN orders ON arrivals_orders.order_id = orders.id"
      ).where("requests.file_id = :file_id OR orders.file_id = :file_id", file_id: id).distinct
  end
  alias_method :external_arrivals, :arrivals

	def set_first_movement
    self.file_movements.create(department_id: self.initial_department, file_type: "Purchases", sended_by: self.user_id)
  end

  def initial_department
    read_attribute(:initial_department) || company.departments.select(:id, :name).find_by(name: 'Compras').try(:id)
  end

  def set_state
    if purchase_requests.empty?
      self.state = "En espera de solicitud"
    elsif budgets.empty?
      self.state = "En espera de presupuesto"
    elsif orders.empty?
      self.state = "En espera de orden de compra"
    elsif arrivals.empty?
      self.state = "En espera de remito"
    elsif bills.empty?
      self.state = "En espera de pago a proveedor"
    else
      self.state = "Finalizado"
    end
    self.save
  end

	def external_arrivals
	  ExternalArrival.all
	end


end
