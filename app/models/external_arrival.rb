class ExternalArrival < ExpedientArrival
	include Notificable
  include MovimientoStock

  belongs_to :supplier, foreign_key: :entity_id
  belongs_to :external_shipment, class_name: "ExternalShipment", foreign_key: :shipment_id, optional: true

	has_many :external_arrivals_expedient_requests, dependent: :destroy, class_name: "ExternalArrivalPurchaseRequest", foreign_key: :arrival_id, inverse_of: :arrival
	has_many :expedient_requests, through: :external_arrivals_expedient_requests, source: :expedient_request
	has_many :external_arrivals_expedient_orders, dependent: :destroy, class_name: "ExternalArrivalOrder", foreign_key: :arrival_id, inverse_of: :arrival
  has_many :expedient_orders, through: :external_arrivals_expedient_orders, source: :expedient_order
  has_many :bill_arrivals, class_name: "ExternalBillArrival", source: :arrival, inverse_of: :expedient_arrival, foreign_key: :arrival_id
	has_many :bills, through: :bill_arrivals
  #has_many :purchase_requests, through: :external_arrivals_expedient_requests, source: :expedient_request, class_name: "ExpedientRequest"

	inherit_details_from :expedient_request
  secondary_assign_details_from :expedient_order

	accepts_nested_attributes_for :external_arrivals_expedient_requests, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :external_arrivals_expedient_orders, reject_if: :all_blank, allow_destroy: true
	after_save :check_if_request_is_fulfilled, :check_shipment_stock, :check_if_active

  scope :traslado_stock, -> {where(traslado_stock_interno: true )}

  def initialize(*args)
    super(*args)
    return unless self.new_record?
    self.number ||= ExternalArrival.generar_number_para_movimiento_stock(ExternalArrival.traslado_stock.count) if self.traslado_stock_interno?
  end

  def department
    "Almacen"
  end

	def check_if_active
		if not active
			details.each(&:destroy)
		end
	end

	def to_s
		"Arribo Nº #{number}"
	end

  def check_shipment_stock
    if saved_change_to_state? && approved?
      expedient_requests.each do |r|
				Expedient.unscoped do
					if r.file.type == "Surgeries::File"
	        	r.file.shipments.each{|s| s.details.each(&:check_stock); s.childs.each(&:check_stock)}
					end
				end
			end
    end
  end

  def at_least_one_request
    external_arrivals_expedient_requests.build if external_arrivals_expedient_requests.size == 0
  end

  def details_attributes=(attrs)
    attrs.each do |_, det|
      det["entity_id"] = entity_id
    end
    super
  end

  def childs_attributes=(attrs)
    attrs.each do |_, det|
      det["entity_id"] = entity_id
    end
    super
  end

  def check_if_request_is_fulfilled
    if saved_change_to_state? && confirmed?
      details.each do |detail|
        if detail.quantity != detail.expedient_requests_details.sum(:quantity)
          manager = company.departments.find_by_name("Compras").try(:user_id)
          Notification::Purchases::Arrival.new(self, current_user, [manager]).for_not_matching
          break
        end
      end
    end
  end

  def has_pdf?
    true
  end

  def notificator
    Notification::ExternalArrivalNotificator.new(self, current_user)
  end

  def file
    nil
  end

	def used?
		bills.any?
	end
end
