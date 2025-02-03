class ExternalShipment < ExpedientShipment
	include Notificable
  include MovimientoStock
  belongs_to :client, foreign_key: :entity_id
	alias_method :entity, :client

  has_many :external_shipment_external_arrivals, foreign_key: :shipment_id, inverse_of: :shipment
  has_many :external_shipments, through: :external_shipment_external_arrivals, source: :arrival
  has_one :external_arrival, foreign_key: :shipment_id # para manejar movimiento de stock interno.
	inherit_details_from :external_arrival
	#validate :enough_stock
	accepts_nested_attributes_for :external_shipment_external_arrivals, reject_if: :all_blank, allow_destroy: true

  scope :traslados, -> {where(shipment_type: "Traslado")}
  scope :traslado_stock, -> {where(traslado_stock_interno: true )}
  scope :by_store, -> (store_id) {where(store_id: store_id )}
  scope :by_store_entrada, -> (store_id) {
    includes(:external_arrival).where(arrivals: {store_id: store_id })
  }
  scope :fecha_desde,-> (fecha) { where('shipments.date >= ?', (fecha.to_date))}
  scope :fecha_hasta,-> (fecha) { where('shipments.date <= ?', (fecha.to_date))}
  scope :entrada_fecha_desde,-> (fecha) { includes(:external_arrival).where('arrivals.date >= ?', (fecha.to_date))}
  scope :entrada_fecha_hasta,-> (fecha) { includes(:external_arrival).where('arrivals.date <= ?', (fecha.to_date))}
  scope :by_estado, -> (estado) {where(state: estado.capitalize )}
  scope :by_estado_entrada, -> (estado) {includes(:external_arrival).where(arrivals: {state: estado.capitalize} )}

  def department
    "Almacen"
  end

  def initialize(*args)
    super(*args)
    return unless self.new_record?
    self.number ||= ExternalShipment.generar_number_para_movimiento_stock(ExternalShipment.traslado_stock.count) if self.traslado_stock_interno?
  end

  # movimiento de stock interno, puedo crearle un arribo a una salida?
  def can_create_arrival?
    self.traslado_stock_interno? && self.external_arrival.blank?
  end

	def check_if_active
		if not active
			details.each(&:destroy)
		end
	end

	def to_s
		"Salida Nº #{number}"
	end

  def at_least_one_request
    #NO BORRAR
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

  def has_pdf?
    true
  end

	def check_stock
    details.each{ |detail| detail.check_stock}
    childs.each{ |child| child.check_stock(self)}
  end

	def enough_stock
    if approved?
      errors.add(:base, "Stock insuficiente en algunos conceptos") if own_details_without_enough_stock.any?
    else
      own_details_without_enough_stock
    end
  end

	def own_products
    (details.reject(&:marked_for_destruction?).select{ |detail| detail.own? && !detail.has_childs?} <<
    childs.reject(&:marked_for_destruction?).select{ |child| child.own? }).flatten
  end

	def own_details_without_enough_stock
    result = []
    own_products.group_by(&:product_id).each do |id, dets|
      quantity  = dets.inject(0){|sum, h| sum + h.quantity}
      available_stock     = dets[0].inventary.available_stock
      if quantity > available_stock
        result <<
          {
            product_id: dets[0].product_id,
            product_name: dets[0].product_name,
            quantity: quantity - available_stock,
            product_measurement: dets[0].product_measurement
          } unless dets.map(&:requested).include?("true")
      end
    end
    return result
  end

  def notificator
    Notification::ExternalShipmentNotificator.new(self, current_user)
  end

	def details_without_enough_stock
    details.select{ |detail| not detail.has_enough_stock? }
  end

  def file
    nil
  end
end
